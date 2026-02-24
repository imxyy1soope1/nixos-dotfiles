use reqwest::Url;
use serde::{Deserialize, Deserializer, de::Error};
use std::net::{SocketAddr, SocketAddrV4};

#[derive(Debug, Clone, Deserialize)]
pub struct AppConfig {
    #[serde(default = "default_listen")]
    pub listen: SocketAddr,
    pub substituters: Vec<Substituter>,
}

impl Default for AppConfig {
    fn default() -> Self {
        Self {
            listen: default_listen(),
            substituters: vec![
                Substituter {
                    url: "https://mirror.sjtu.edu.cn/nix-channels/store",
                    penalty: 0,
                },
                Substituter {
                    url: "https://mirrors.ustc.edu.cn/nix-channels/store",
                    penalty: 0,
                },
                Substituter {
                    url: "https://cache.nixos.org",
                    penalty: 100,
                },
            ],
        }
    }
}

fn default_listen() -> SocketAddr {
    SocketAddr::V4(SocketAddrV4::new([127, 0, 0, 1].into(), 2048))
}

#[derive(Debug, Clone)]
pub struct Substituter {
    pub url: &'static str,
    pub penalty: u32,
}

impl<'de> Deserialize<'de> for Substituter {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        #[derive(Debug, Clone, Deserialize)]
        struct ShadowSubstituter {
            url: String,
            #[serde(default)]
            penalty: u32,
        }
        let sub = <ShadowSubstituter as Deserialize>::deserialize(deserializer);
        sub.and_then(|ShadowSubstituter { url, penalty }| {
            let url = match Url::parse(&url) {
                Ok(url) => Ok(Box::leak(url.to_string().into_boxed_str())),
                Err(err) => Err(<D::Error as Error>::custom(err.to_string())),
            }?;
            Ok(Substituter { url, penalty })
        })
    }
}
