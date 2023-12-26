{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;

  networking.networkmanager.enable = true;
}
