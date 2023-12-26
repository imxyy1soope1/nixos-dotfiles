{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;

  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
