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
    sshKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.my.persist.location}/home/${username}/.ssh/id_ed25519";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.age.sshKeyFile = cfg.sshKeyFile;
    users.users.${username}.extraGroups = [ "keys" ];
    my.home = {
      sops.age.sshKeyFile = cfg.sshKeyFile;
      home.packages = [
        pkgs.sops
      ];
      home.sessionVariables.SOPS_AGE_SSH_PRIVATE_KEY_FILE = cfg.sshKeyFile;
    };
  };
}
