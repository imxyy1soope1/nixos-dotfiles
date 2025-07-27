{
  lib,
  config,
  username,
  secrets,
  ...
}:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    grub.enable = false;
    timeout = 0;
  };

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/cache/nix";
    serviceConfig.CacheDirectory = "nix";
  };
  environment.variables.NIX_REMOTE = "daemon";

  my.audio.enable = false;

  sops.secrets.imxyy-nix-server-hashed-password = {
    sopsFile = secrets.imxyy-nix-server-hashed-password;
    format = "binary";
    neededForUsers = true;
  };
  users.users.${username}.hashedPasswordFile =
    lib.mkForce config.sops.secrets.imxyy-nix-server-hashed-password.path;
  users.users.root.hashedPasswordFile = lib.mkForce config.sops.secrets.imxyy-nix-server-hashed-password.path;
}
