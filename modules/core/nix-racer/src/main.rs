use std::{
    collections::HashMap,
    sync::Arc,
    time::{Duration, Instant},
};

use axum::{
    Router,
    extract::{Path, State},
    http::{StatusCode, header},
    response::{IntoResponse, Redirect},
    routing::get,
};
use reqwest::Client;
use tokio::task::JoinSet;
use tracing_subscriber::{EnvFilter, layer::SubscriberExt as _, util::SubscriberInitExt as _};

mod config;
use config::*;

#[derive(Clone)]
struct AppState {
    client: Client,
    config: Arc<AppConfig>,
}

#[tokio::main]
async fn main() {
    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .with(
            EnvFilter::builder()
                .with_env_var("NIX_RACER_LOG")
                .with_default_directive("nix_racer=debug".parse().unwrap())
                .from_env()
                .unwrap(),
        )
        .init();

    let config: Arc<AppConfig> = match std::fs::read_to_string("/etc/nix/nix-racer.toml") {
        Ok(file) => toml::from_str::<AppConfig>(&file).unwrap_or_else(|x| {
            tracing::warn!("Failed to parse config file ({x}), fallback to default configuration");
            AppConfig::default()
        }),
        Err(err) if err.kind() == std::io::ErrorKind::NotFound => {
            tracing::info!("Config file not found, fallback to default configuration");
            AppConfig::default()
        }
        Err(err) => {
            tracing::warn!("Failed to read config file ({err}), fallback to default configuration");
            AppConfig::default()
        }
    }
    .into();

    if config.substituters.is_empty() {
        tracing::error!("No substituters found");
        std::process::exit(1);
    }

    let listen = config.listen;

    let client = Client::builder()
        .timeout(Duration::from_secs(5))
        .pool_idle_timeout(Duration::from_secs(90))
        .build()
        .unwrap();

    let state = AppState { client, config };

    let listener = tokio::net::TcpListener::bind(listen).await.unwrap();

    let app = Router::new()
        .route("/nix-cache-info", get(nix_cache_info_handler))
        .route("/{*path}", get(proxy_handler))
        .with_state(state);

    tracing::info!("Smart Nix Proxy listening on http://{listen}");
    axum::serve(listener, app).await.unwrap();
}

async fn nix_cache_info_handler() -> impl IntoResponse {
    let info = "StoreDir: /nix/store\nWantMassQuery: 1\nPriority: 30\n";
    ([(header::CONTENT_TYPE, "text/x-nix-cache-info")], info)
}

async fn proxy_handler(
    Path(path): Path<String>,
    State(state): State<AppState>,
) -> impl IntoResponse {
    if !path.ends_with(".narinfo") {
        let redirect_url = format!("{}/{}", state.config.substituters[0].url, path);
        return Redirect::temporary(&redirect_url).into_response();
    }

    let start_time = Instant::now();
    let mut set = JoinSet::new();

    let mut penalties = HashMap::new();

    for upstream in state.config.substituters.iter() {
        let url = format!("{}/{}", upstream.url, path);
        let client = state.client.clone();
        let base_url = upstream.url;

        let handle = set.spawn(async move {
            let max_retries = 2;
            let mut delay = Duration::from_millis(50);

            for attempt in 0..=max_retries {
                match client.get(&url).send().await {
                    Ok(resp) if resp.status().is_success() => {
                        let bytes = resp.bytes().await.map_err(|_| "Body error")?;

                        let text = String::from_utf8_lossy(&bytes);
                        let mut new_text = String::with_capacity(text.len() + 64);
                        for line in text.lines() {
                            if let Some(rel_url) = line.strip_prefix("URL: ") {
                                if rel_url.starts_with("http://") || rel_url.starts_with("https://")
                                {
                                    new_text.push_str(line);
                                } else {
                                    new_text.push_str(&format!("URL: {}/{}", base_url, rel_url));
                                }
                            } else {
                                new_text.push_str(line);
                            }
                            new_text.push('\n');
                        }
                        return Ok((new_text.into_bytes(), base_url));
                    }
                    Ok(resp) if resp.status() == StatusCode::NOT_FOUND => return Err("404"),
                    Err(_) => {
                        if attempt == max_retries {
                            return Err("Max retries");
                        }
                        tokio::time::sleep(delay).await;
                        delay *= 2;
                    }
                    _ => return Err("Other HTTP Error"),
                }
            }
            Err("Unreachable")
        });

        penalties.insert(handle.id(), upstream.penalty);
    }

    struct ProxyResult {
        score: Duration,
        body: Vec<u8>,
        url: &'static str,
    }
    let mut best_result: Option<ProxyResult> = None;

    loop {
        let min_active_penalty = penalties.values().min().copied();

        if let Some(ProxyResult { score, .. }) = best_result {
            if let Some(min_p) = min_active_penalty {
                if start_time.elapsed() + Duration::from_millis(u64::from(min_p)) >= score {
                    break;
                }
            } else {
                break;
            }
        } else if min_active_penalty.is_none() {
            break;
        }

        let timeout_dur = if let Some(ProxyResult { score, .. }) = best_result {
            score.saturating_sub(start_time.elapsed())
        } else {
            Duration::from_secs(86400)
        };

        if timeout_dur.is_zero() && best_result.is_some() {
            break;
        }

        let res = tokio::time::timeout(timeout_dur, set.join_next_with_id()).await;

        match res {
            Ok(Some(Ok((task_id, task_res)))) => {
                let penalty = penalties.remove(&task_id).unwrap();
                if let Ok((body, url)) = task_res {
                    let score = start_time.elapsed() + Duration::from_millis(u64::from(penalty));
                    if best_result.as_ref().is_none_or(|best| score < best.score) {
                        best_result = Some(ProxyResult { score, body, url })
                    }
                }
            }
            Ok(Some(Err(join_err))) => {
                penalties.remove(&join_err.id());
            }
            Ok(None) => break,
            Err(_) => break,
        }
    }

    if let Some(ProxyResult { score, body, url }) = best_result {
        tracing::debug!("Winner for {}: {} (Score: {:?})", path, url, score,);
        (
            StatusCode::OK,
            [(header::CONTENT_TYPE, "text/x-nix-narinfo")],
            body,
        )
            .into_response()
    } else {
        (StatusCode::NOT_FOUND, "Not Found").into_response()
    }
}
