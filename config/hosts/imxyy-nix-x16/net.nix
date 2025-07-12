{
  config,
  lib,
  pkgs,
  sopsRoot,
  ...
}:
{
  boot.kernelParams = [
    "biosdevname=0"
    "net.ifnames=0"
  ];
  networking.wireless.enable = true;
  networking.wireless.userControlled = true;

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
    wpa_supplicant
    wpa_supplicant_gui
  ];
  systemd.services."easytier" = {
    enable = true;
    script = "${pkgs.easytier}/bin/easytier-core -c ${config.sops.secrets.et-imxyy-nix-x16.path}";
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
  };
}
