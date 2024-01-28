{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.tmp.useTmpfs = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/0404de0a-9c4d-4c98-b3e5-b8ff8115f36c";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=root" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/d80ff9a8-6b6b-4388-9a93-3ba3ad240686";
      fsType = "xfs";
    };

  fileSystems."/persistent" =
    {
      device = "/dev/disk/by-uuid/0404de0a-9c4d-4c98-b3e5-b8ff8115f36c";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=persistent" ];
      neededForBoot = true;
    };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-uuid/0404de0a-9c4d-4c98-b3e5-b8ff8115f36c /btrfs_tmp
    mkdir -p /btrfs_tmp/old_roots
    if [[ -e /btrfs_tmp/root ]]; then
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +14); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/3B3D-1AD5";
      fsType = "vfat";
    };

  fileSystems."/home/imxyy/Documents" =
    {
      device = "/dev/disk/by-uuid/a4e37dcd-764a-418c-aa1c-484f1fbd4bbe";
      fsType = "ext4";
    };

  fileSystems."/home/imxyy/Downloads" =
    {
      device = "/dev/disk/by-uuid/18717cb4-49ac-40fa-95d4-29523a458dd0";
      fsType = "ext4";
    };

  fileSystems."/home/imxyy/Videos" =
    {
      device = "/dev/disk/by-uuid/b67bbeab-58bc-4814-b5e3-08404e78b25e";
      fsType = "ext4";
    };

  fileSystems."/home/imxyy/Pictures" =
    {
      device = "/dev/disk/by-uuid/a31bfe7e-cc17-4bd2-af74-ae5de9be35d3";
      fsType = "ext4";
    };

  fileSystems."/home/imxyy/Music" =
    {
      device = "/dev/disk/by-uuid/2d5c16b2-bcd4-47e4-bcdb-fc09e49993f2";
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
