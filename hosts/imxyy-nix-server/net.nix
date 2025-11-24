{
  config,
  lib,
  pkgs,
  username,
  hosts,
  secrets,
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
  users.users.root.openssh.authorizedKeys.keys = lib.mapAttrsToList (
    host: key: "${key} ${host}"
  ) hosts;
  users.users.${username}.openssh.authorizedKeys.keys = lib.mapAttrsToList (
    host: key: "${key} ${host}"
  ) hosts;

  sops.secrets.dae-imxyy-nix-server = {
    sopsFile = secrets.dae-imxyy-nix-server;
    restartUnits = [ "dae.service" ];
    format = "binary";
  };
  services.dae = {
    enable = true;
    configFile = config.sops.secrets.dae-imxyy-nix-server.path;
  };
  systemd.services.dae = {
    after = [ "sops-nix.service" ];
    serviceConfig.MemoryMax = "1G";
  };
  sops.secrets.mihomo = {
    sopsFile = secrets.mihomo;
    restartUnits = [ "mihomo.service" ];
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
    sopsFile = secrets.frp;
    restartUnits = [ "frp.service" ];
    format = "dotenv";
  };
  systemd.services.frp.serviceConfig.EnvironmentFile = [
    config.sops.secrets.frp-env.path
  ];
  services.frp = {
    instances."" = {
      enable = true;
      role = "client";
      settings = {
        serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}";
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
            name = "matrix-root-http";
            type = "http";
            localIP = "127.0.0.1";
            localPort = 80;
            customDomains = [ "imxyy.top" ];
          }
          {
            name = "matrix-root-https";
            type = "https";
            localIP = "127.0.0.1";
            localPort = 443;
            customDomains = [ "imxyy.top" ];
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
            name = "immich-http";
            type = "http";
            localIP = "127.0.0.1";
            localPort = 80;
            customDomains = [ "immich.imxyy.top" ];
          }
          {
            name = "immich-https";
            type = "https";
            localIP = "127.0.0.1";
            localPort = 443;
            customDomains = [ "immich.imxyy.top" ];
          }

          {
            name = "memo-http";
            type = "http";
            localIP = "127.0.0.1";
            localPort = 80;
            customDomains = [ "memo.imxyy.top" ];
          }
          {
            name = "memo-https";
            type = "https";
            localIP = "127.0.0.1";
            localPort = 443;
            customDomains = [ "memo.imxyy.top" ];
          }

          {
            name = "efl-matrix-http";
            type = "http";
            localIP = "127.0.0.1";
            localPort = 80;
            customDomains = [ "mtx.eflx.top" ];
          }
          {
            name = "efl-matrix-https";
            type = "https";
            localIP = "127.0.0.1";
            localPort = 443;
            customDomains = [ "mtx.eflx.top" ];
          }
          {
            name = "efl-send-http";
            type = "http";
            localIP = "127.0.0.1";
            localPort = 80;
            customDomains = [ "send.eflx.top" ];
          }
          {
            name = "efl-send-https";
            type = "https";
            localIP = "127.0.0.1";
            localPort = 443;
            customDomains = [ "send.eflx.top" ];
          }
        ];
      };
    };
  };

  sops.secrets.et-imxyy-nix-server = {
    sopsFile = secrets.et-imxyy-nix-server;
    restartUnits = [ "easytier.service" ];
    format = "binary";
  };
  environment.systemPackages = [ pkgs.easytier ];
  systemd.services."easytier" = {
    enable = true;
    script = "${pkgs.easytier}/bin/easytier-core -c ${config.sops.secrets.et-imxyy-nix-server.path}";
    serviceConfig = {
      Restart = "always";
      RestartSec = 30;
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "sops-nix.service"
    ];
  };

  virtualisation.oci-containers.containers.obligator = {
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
  services.caddy.virtualHosts."oidc.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8081 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };

  systemd.services.ddns-go =
    let
      version = "6.6.7";
      ddns-go = pkgs.buildGoModule {
        inherit version;
        pname = "ddns-go";
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
        "matrix"
        "note"
        "oidc"
        "mc"
        "music"
        "sy"
        "immich"
      ];
    in
    {
      enable = true;
      resolveLocalQueries = false;
      settings = {
        no-resolv = true;
        server = [ "192.168.3.1" ];
        address = map (sub: "/${sub}.imxyy.top/192.168.3.2") subDomains ++ [
          "/imxyy-nix-server/192.168.3.2"
          "/imxyy-cloudwin/192.168.3.4"
          "/printer.home/192.168.3.53"
        ];
        cache-size = 0;
        log-queries = "extra";
      };
    };
}
