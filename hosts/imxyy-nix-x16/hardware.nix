{
  config,
  lib,
  pkgs,
  ...
}:
let
  btrfs = "/dev/disk/by-uuid/69ab72d4-6ced-4f70-8b5e-aa2daa8c0b6b";
in
{
  boot = {
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "uas"
        "sd_mod"
      ];
      verbose = false;
    };

    kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;
    kernelModules = [ "kvm-amd" ];

    tmp.useTmpfs = true;
    kernel.sysctl = {
      "fs.file-max" = 9223372036854775807;
    };
  };

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

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/96D3-93B0";
    fsType = "vfat";
    options = [
      "uid=0"
      "gid=0"
      "fmask=0077"
      "dmask=0077"
    ];
  };

  networking.useDHCP = lib.mkDefault false;

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
}
