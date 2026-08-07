{
  config,
  lib,
  pkgs,
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
        interface eth0
          noipv4
      '';
    };
    interfaces = {
      eth0 = {
        useDHCP = lib.mkForce true;
        wakeOnLan.enable = true;
        ipv4 = {
          addresses = [
            {
              address = "192.168.3.3";
              prefixLength = 24;
            }
          ];
        };
      };
    };
    defaultGateway = {
      address = "192.168.3.1";
      interface = "eth0";
    };
    nameservers = [
      "192.168.3.2"
    ];

    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = false;
      trustedInterfaces = [ "waydroid0" ];
      extraInputRules = ''
        ip saddr { 10.0.0.0/8, 100.64.0.0/10, 172.16.0.0/12, 192.168.0.0/16, 169.254.0.0/16 } accept
        ip6 saddr { fd00::/8, fe80::/10 } accept
      '';
      filterForward = true;
      extraForwardRules = ''
        iifname waydroid0 accept
        oifname waydroid0 accept
      '';
    };
    nftables.enable = true;
  };

  sops.secrets.dae-imxyy-nix = {
    sopsFile = secrets.dae-imxyy-nix;
    restartUnits = [ "dae.service" ];
    format = "binary";
  };
  services.dae = {
    enable = true;
    configFile = config.sops.secrets.dae-imxyy-nix.path;
    openFirewall.enable = false;
  };
  systemd.services.dae.after = [ "sops-nix.service" ];
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

  sops.secrets.et-imxyy-nix = {
    sopsFile = secrets.et-imxyy-nix;
    restartUnits = [ "easytier.service" ];
    format = "binary";
  };
  environment.systemPackages = [ pkgs.easytier ];
  systemd.services."easytier" = {
    enable = true;
    script = "${pkgs.easytier}/bin/easytier-core -c ${config.sops.secrets.et-imxyy-nix.path}";
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
