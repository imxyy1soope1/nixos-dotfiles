{
  lib,
  config,
  pkgs,
  secrets,
  hosts,
  ...
}:
{
  sops.secrets.et-imxyy-nix-server-nixremote = {
    sopsFile = secrets.et-imxyy-nix-server-nixremote;
    restartUnits = [ "easytier-nixremote.service" ];
    format = "binary";
  };
  environment.systemPackages = [ pkgs.easytier ];
  systemd.services."easytier-nixremote" = {
    enable = true;
    script = "${pkgs.easytier}/bin/easytier-core -c ${config.sops.secrets.et-imxyy-nix-server-nixremote.path}";
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
  users.groups.nixremote = { };
  users.users.nixremote = {
    isSystemUser = true;
    description = "nix remote build user";
    group = "nixremote";
    openssh.authorizedKeys.keys = (lib.mapAttrsToList (host: key: "${key} ${host}") hosts) ++ [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIENauvvhVMLsUwH9cPYsvnOg7VCL3a4yEiKm8I524TE efl@efl-nix"
    ];
  };
  nix.settings.trusted-users = [
    "nixremote"
  ];
}
