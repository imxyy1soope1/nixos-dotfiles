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

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "524288";
    }
  ];

  # Graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Printing service
  services.printing.enable = true;

  # GVFS for virtual filesystems
  services.gvfs.enable = true;

  # Enable desktop-related modules by default
  my = {
    audio.enable = true;
    bluetooth.enable = true;
    fonts.enable = true;
  };

  # Desktop persistence
  my.persist = {
    enable = lib.mkDefault true;
    location = lib.mkDefault "/nix/persist";
  };
}
