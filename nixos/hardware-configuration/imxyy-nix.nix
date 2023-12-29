{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0404de0a-9c4d-4c98-b3e5-b8ff8115f36c";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=root" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/0404de0a-9c4d-4c98-b3e5-b8ff8115f36c";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AA66-1C0C";
      fsType = "vfat";
    };

  fileSystems."/home/imxyy/Documents" =
    { device = "/dev/disk/by-uuid/a4e37dcd-764a-418c-aa1c-484f1fbd4bbe";
      fsType = "ext4";
    };

  fileSystems."/home/imxyy/Downloads" =
    { device = "/dev/disk/by-uuid/18717cb4-49ac-40fa-95d4-29523a458dd0";
      fsType = "ext4";
    };

  fileSystems."/home/imxyy/Videos" =
    { device = "/dev/disk/by-uuid/b67bbeab-58bc-4814-b5e3-08404e78b25e";
      fsType = "ext4";
    };

  fileSystems."/home/imxyy/Pictures" =
    { device = "/dev/disk/by-uuid/a31bfe7e-cc17-4bd2-af74-ae5de9be35d3";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
