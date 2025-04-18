{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.my.sops;
in
{
  options.my.sops = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    sshKeyPath = lib.mkOption {
      type = lib.types.str;
      default = "/persistent/home/${username}/.ssh/id_ed25519";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.age.sshKeyPaths = [
      cfg.sshKeyPath
    ];
    users.users.${username}.extraGroups = [ "keys" ];
    environment.variables.SOPS_AGE_KEY_FILE = "/run/secrets.d/age-keys.txt";
    my.home = {
      sops.age.sshKeyPaths = [
        cfg.sshKeyPath
      ];
      home.packages = [
        pkgs.sops
      ];
    };
  };
}
