{ lib, ... }:
{
  # Boot loader configuration
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    grub.enable = false;
    timeout = 0;
  };

  # Disable desktop features on servers
  my = {
    audio.enable = false;
    bluetooth.enable = false;
    fonts.enable = false;
  };

  # Server persistence
  my.persist = {
    enable = lib.mkDefault true;
    location = lib.mkDefault "/nix/persist";
  };
}
