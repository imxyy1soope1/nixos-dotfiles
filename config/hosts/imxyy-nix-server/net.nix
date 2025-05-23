{
  config,
  lib,
  pkgs,
  username,
  sopsRoot,
  ...
}:
{
  boot.kernelParams = [
    "biosdevname=0"
    "net.ifnames=0"
  ];
  networking = {
    useDHCP = lib.mkForce false;
    dhcpcd = {
      wait = "background";
      IPv6rs = true;
      extraConfig = ''
        interface mac0
          noipv4
      '';
    };
    interfaces = {
      eth0.wakeOnLan.enable = true;
      eth1.wakeOnLan.enable = true;
      mac0 = {
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "192.168.3.2";
            prefixLength = 24;
          }
        ];
      };
    };
    macvlans."mac0" = {
      interface = "eth0";
      mode = "bridge";
    };
    defaultGateway = {
      address = "192.168.3.1";
      interface = "mac0";
    };
    nameservers = [
      "192.168.3.1"
      "192.168.3.2"
    ];

    firewall.enable = false;
    nftables = {
      enable = true;
      flushRuleset = true;
      ruleset = ''
        table inet firewall {
          set LANv4 {
            type ipv4_addr
            flags interval

            elements = { 10.0.0.0/8, 100.64.0.0/10, 172.16.0.0/12, 192.168.0.0/16, 169.254.0.0/16 }
          }
          set LANv6 {
            type ipv6_addr
            flags interval

            elements = { fd00::/8, fe80::/10 }
          }
          set tcp_ports {
            type inet_service
            flags interval

            elements = {
              http,
              https,
              2222,
              25565
            }
          }

          chain prerouting {
            type filter hook prerouting priority mangle; policy accept;

            ip daddr @LANv4 accept
            ip6 daddr @LANv6 accept
          }

          chain output {
            type filter hook output priority 100; policy accept;

            ip daddr @LANv4 accept
            ip6 daddr @LANv6 accept
          }

          chain input {
            type filter hook input priority 0; policy drop;
            iif lo accept
            ct state invalid drop
            ct state established,related accept

            ip protocol { icmp, igmp } accept

            ip saddr @LANv4 accept
            ip6 saddr @LANv6 accept

            tcp dport 2222 ct state new limit rate 15/minute counter accept

            tcp dport @tcp_ports counter accept
          }

          chain forward {
            type filter hook forward priority 0; policy accept;
          }

          chain nat {
            type nat hook postrouting priority 0; policy accept;
            ip saddr 192.168.3.0/24 masquerade
          }
        }
      '';
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      # PermitRootLogin = "yes";
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBWOy0QmAyxENg/O5m3cus8U3c9jCLioivwcWsh5/a82 imxyy-hisense-pad"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8pivvE8PMtsOxmccfNhH/4KehDKhBfUfJbQZxo/SZT imxyy-ace5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKALTBn/QSGcSPgMg0ViSazFcaA0+nEF05EJpjbsI6dE imxyy_soope_@imxyy-cloudwin"
  ];
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBWOy0QmAyxENg/O5m3cus8U3c9jCLioivwcWsh5/a82 imxyy-hisense-pad"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8pivvE8PMtsOxmccfNhH/4KehDKhBfUfJbQZxo/SZT imxyy-ace5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKALTBn/QSGcSPgMg0ViSazFcaA0+nEF05EJpjbsI6dE imxyy_soope_@imxyy-cloudwin"
  ];

  sops.secrets.dae-imxyy-nix-server = {
    sopsFile = sopsRoot + /dae-imxyy-nix-server.dae;
    format = "binary";
  };
  services.dae = {
    enable = true;
    configFile = config.sops.secrets.dae-imxyy-nix-server.path;
  };
  systemd.services.dae.after = [ "sops-nix.service" ];
  sops.secrets.mihomo = {
    sopsFile = sopsRoot + /mihomo.yaml;
    format = "yaml";
    key = "";
  };
  systemd.services.mihomo.after = [ "sops-nix.service" ];
  services.mihomo = {
    enable = true;
    configFile = config.sops.secrets.mihomo.path;
    webui = pkgs.metacubexd;
  };

  sops.secrets.frp-env = {
    sopsFile = sopsRoot + /frp.env;
    format = "dotenv";
  };
  systemd.services.frp.serviceConfig.EnvironmentFile = [
    config.sops.secrets.frp-env.path
  ];
  services.frp = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "hk.imxyy.top";
      serverPort = 7000;
      auth.token = "{{ .Envs.FRP_AUTH_TOKEN }}";
      proxies = [
        {
          name = "nextcloud-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "nextcloud.imxyy.top" ];
        }
        {
          name = "nextcloud-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "nextcloud.imxyy.top" ];
        }

        {
          name = "oidc-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "oidc.imxyy.top" ];
        }
        {
          name = "oidc-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "oidc.imxyy.top" ];
        }
        {
          name = "headscale-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "headscale.imxyy.top" ];
        }
        {
          name = "headscale-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "headscale.imxyy.top" ];
        }

        {
          name = "mail-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "mail.imxyy.top" ];
        }
        {
          name = "mail-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "mail.imxyy.top" ];
        }

        {
          name = "gitea-ssh";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 2222;
          remotePort = 2222;
        }
        {
          name = "gitea-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "git.imxyy.top" ];
        }
        {
          name = "gitea-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "git.imxyy.top" ];
        }

        {
          name = "vault-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "vault.imxyy.top" ];
        }
        {
          name = "vault-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "vault.imxyy.top" ];
        }

        {
          name = "home-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "home.imxyy.top" ];
        }
        {
          name = "home-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "home.imxyy.top" ];
        }

        {
          name = "coder-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "coder.imxyy.top" ];
        }
        {
          name = "coder-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "coder.imxyy.top" ];
        }

        {
          name = "music-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "music.imxyy.top" ];
        }
        {
          name = "music-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "music.imxyy.top" ];
        }

        {
          name = "ai-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "ai.imxyy.top" ];
        }
        {
          name = "ai-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "ai.imxyy.top" ];
        }

        {
          name = "grafana-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "grafana.imxyy.top" ];
        }
        {
          name = "grafana-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "grafana.imxyy.top" ];
        }

        {
          name = "note-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "note.imxyy.top" ];
        }
        {
          name = "note-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "note.imxyy.top" ];
        }

        {
          name = "siyuan-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "sy.imxyy.top" ];
        }
        {
          name = "siyuan-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "sy.imxyy.top" ];
        }

        {
          name = "matrix-http";
          type = "http";
          localIP = "127.0.0.1";
          localPort = 80;
          customDomains = [ "matrix.imxyy.top" ];
        }
        {
          name = "matrix-https";
          type = "https";
          localIP = "127.0.0.1";
          localPort = 443;
          customDomains = [ "matrix.imxyy.top" ];
        }

        {
          name = "minecraft";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 25565;
          remotePort = 25565;
        }
      ];
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraSetFlags = [ "--accept-dns=false" ];
  };
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8080;
    settings = {
      logtail.enabled = false;
      server_url = "https://headscale.imxyy.top";
      dns = {
        base_domain = "tailnet.imxyy.top";
        extra_records = [
          {
            "name" = "home.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "nextcloud.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "mail.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "git.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "vault.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "mc.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "home.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "coder.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
          {
            "name" = "music.imxyy.top";
            "type" = "A";
            "value" = "100.64.0.2";
          }
        ];
      };
      ip_prefixes = "100.64.0.0/10";
      derp.paths = [
        (toString (
          pkgs.writeText "derp.yaml" ''
            regions:
              900:
                regionid: 900
                regioncode: custom-tok
                regionname: imxyy_soope_ Tokyo
                nodes:
                  - name: 900a
                    regionid: 900
                    hostname: vkvm.imxyy.top
              # 901:
              #   regionid: 901
              #   regioncode: custom-cn
              #   regionname: imxyy_soope_ Hu Bei
              #   nodes:
              #     - name: 901a
              #       regionid: 901
              #       hostname: ry.imxyy.top
              #       derpport: 1443
          ''
        ))
      ];
      derp.urls = lib.mkForce [ ];

      oidc = {
        only_start_if_oidc_is_available = true;
        issuer = "https://oidc.imxyy.top";
        client_id = "https://headscale.imxyy.top";
        allowed_domains = [
          "imxyy.top"
          "*.imxyy.top"
        ];
        client_secret = "";
        expiry = 0;
        extra_params.domain_hint = "imxyy.top";
        strip_email_domain = true;
      };
    };
  };
  systemd.services."headscale" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "podman-obligator.service"
    ];
    requires = [
      "podman-obligator.service"
    ];
  };

  sops.secrets.et-imxyy-nix-server = {
    sopsFile = sopsRoot + /et-imxyy-nix-server.toml;
    format = "binary";
  };
  environment.systemPackages = [ pkgs.easytier ];
  systemd.services."easytier" = {
    enable = true;
    script = "easytier-core -c ${config.sops.secrets.et-imxyy-nix-server.path}";
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "sops-nix.service"
    ];
    path = with pkgs; [
      easytier
      iproute2
      bash
    ];
  };

  virtualisation.oci-containers = {
    containers = {
      obligator = {
        image = "anderspitman/obligator:latest";
        volumes = [
          "/var/lib/obligator:/data"
          "/var/lib/obligator:/api"
        ];
        ports = [ "8081:1616" ];
        cmd = [
          "-storage-dir"
          "/data"
          "-api-socket-dir"
          "/api"
          "-root-uri"
          "https://oidc.imxyy.top"
          "-port"
          "1616"
        ];
      };
    };
  };
  services.caddy.virtualHosts."headscale.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8080 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
  services.caddy.virtualHosts."oidc.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8081 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };

  systemd.services.ddns-go =
    let
      ddns-go = pkgs.buildGoModule rec {
        pname = "ddns-go";
        version = "6.6.7";
        src = pkgs.fetchFromGitHub {
          owner = "jeessy2";
          repo = "ddns-go";
          rev = "v${version}";
          hash = "sha256-Ejoe6e9GFhHxQ9oIBDgDRQW9Xx1XZK+qSAXiRXLdn+c=";
        };
        meta.mainProgram = "ddns-go";
        vendorHash = "sha256-XZii7gV3DmTunYyGYzt5xXhv/VpTPIoYKbW4LnmlAgs=";
        doCheck = false;
      };
    in
    {
      description = "Go Dynamic DNS";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe ddns-go} -l :9876 -f 10 -cacheTimes 180 -c /var/lib/ddns-go/config.yaml";
        Restart = "always";
        RestartSec = 120;
      };
      path = [
        pkgs.bash
      ];
    };

  services.dnsmasq =
    let
      subDomains = [
        "home"
        "nextcloud"
        "mail"
        "git"
        "vault"
        "coder"
        "headscale"
        "oidc"
        "mc"
        "music"
        "ai"
      ];
    in
    {
      enable = true;
      resolveLocalQueries = false;
      settings = {
        server = [
          "120.53.53.53"
          "223.5.5.5"
        ];
        address = map (sub: "/${sub}.imxyy.top/192.168.3.2") subDomains ++ [
          "/imxyy-nix-server/192.168.3.2"
          "/imxyy-cloudwin/192.168.3.4"
          "/printer.home/192.168.3.53"
        ];
        cache-size = 0;
      };
    };
}
