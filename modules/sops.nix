{
  config,
  pkgs,
  lib,
  username,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "sops secret settings";
  optionPath = [ "sops" ];
  config' = {
    sops.age.sshKeyPaths = [
      "/persistent/home/${username}/.ssh/id_ed25519"
    ];
    users.users.${username}.extraGroups = [ "keys" ];
    environment.variables.SOPS_AGE_KEY_FILE = "/run/secrets.d/age-keys.txt";
    my.home = {
      sops.age.sshKeyPaths = [
        "/persistent/home/${username}/.ssh/id_ed25519"
      ];
      home.packages = [
        pkgs.sops
      ];
    };
  };
}
