{
  config,
  lib,
  pkgs,
  ...
}:
let
  btrfs = "/dev/disk/by-uuid/1e1b403d-4a04-46ee-a6eb-cb4dd5f793a2";
in
{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod; # LTS
  boot.extraModulePackages = [ ];
  boot.tmp.useTmpfs = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    extraPools = [ "data" ];
    forceImportRoot = false;
  };
  services.zfs.autoScrub.enable = true;
  services.btrfs.autoScrub.enable = true;
  networking.hostId = "10ca95b4";

  my.persist.btrfs = {
    device = btrfs;
    mountPoint = "/nix/persist";
    persistSubvol = "persist";
    rootSubvol = "root";
    zstdCompress = true;
  };

  fileSystems."/nix" = {
    device = btrfs;
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=nix"
    ];
  };

  fileSystems."/swap" = {
    device = btrfs;
    fsType = "btrfs";
    options = [
      "noatime"
      "subvol=swap"
    ];
    neededForBoot = true;
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 24 * 1024;
    }
  ];
  boot.zswap.enable = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/58F4-135A";
    fsType = "vfat";
    options = [
      "uid=0"
      "gid=0"
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
}
