{
  lib,
  config,
  username,
  sopsRoot,
  ...
}:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    grub.enable = false;
    timeout = 0;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/cache/nix";
    serviceConfig.CacheDirectory = "nix";
  };
  environment.variables.NIX_REMOTE = "daemon";

  sops.secrets.imxyy-nix-server-hashed-password = {
    sopsFile = sopsRoot + /imxyy-nix-server-hashed-password.txt;
    format = "binary";
  };
  users.users.${username}.hashedPasswordFile =
    lib.mkForce config.sops.secrets.imxyy-nix-server-hashed-password.path;
  users.users.root.hashedPasswordPath = lib.mkForce config.sops.secrets.imxyy-nix-server-hashed-password.path;
}
