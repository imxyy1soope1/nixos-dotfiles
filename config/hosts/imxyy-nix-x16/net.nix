{
  config,
  pkgs,
  sopsRoot,
  ...
}:
{
  boot.kernelParams = [
    "biosdevname=0"
    "net.ifnames=0"
  ];
  networking = {
    networkmanager.enable = true;
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

          chain output {
            type filter hook output priority 100; policy accept;
          }

          chain input {
            type filter hook input priority 0; policy drop;
            iif lo accept
            ct state invalid drop
            ct state established,related accept

            ip saddr @LANv4 accept
            ip6 saddr @LANv6 accept
          }

          chain forward {
            type filter hook forward priority 0; policy drop;
          }
        }
      '';
    };
  };

  sops.secrets.dae-imxyy-nix-x16 = {
    sopsFile = sopsRoot + /dae-imxyy-nix-x16.dae;
    format = "binary";
  };
  services.dae = {
    enable = true;
    configFile = config.sops.secrets.dae-imxyy-nix-x16.path;
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

  sops.secrets.et-imxyy-nix-x16 = {
    sopsFile = sopsRoot + /et-imxyy-nix-x16.toml;
    format = "binary";
  };
  environment.systemPackages = with pkgs; [
    easytier
  ];
  systemd.services."easytier" = {
    enable = true;
    script = "${pkgs.easytier}/bin/easytier-core -c ${config.sops.secrets.et-imxyy-nix-x16.path}";
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
}
