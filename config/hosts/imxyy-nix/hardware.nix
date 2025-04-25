{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  btrfs = "/dev/disk/by-uuid/0404de0a-9c4d-4c98-b3e5-b8ff8115f36c";
in
{
  boot = {
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      verbose = false;
    };

    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_zen;
    kernelModules = [ "kvm-amd" ];

    tmp.useTmpfs = true;
    kernel.sysctl = {
      "fs.file-max" = 9223372036854775807;
    };

    resumeDevice = btrfs;
    kernelParams = [
      "resume_offset=6444127"
    ];
  };

  fileSystems."/" = {
    device = btrfs;
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=root"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/843c36ae-f6d0-46a1-b5c7-8ab569e1e63f";
    fsType = "btrfs";
    options = [ "compress=zstd" ];
  };

  my.persist.location = "/nix/persist";
  fileSystems."/nix/persist" = {
    device = btrfs;
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=persistent"
    ];
    neededForBoot = true;
  };

  fileSystems."/swap" = {
    device = btrfs;
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=swap"
    ];
    neededForBoot = true;
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount ${btrfs} /btrfs_tmp
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

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B7DC-E9AC";
    fsType = "vfat";
    options = [
      "uid=0"
      "gid=0"
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/home/${username}/Documents" = {
    device = "/dev/disk/by-uuid/a4e37dcd-764a-418c-aa1c-484f1fbd4bbe";
    fsType = "ext4";
  };

  fileSystems."/home/${username}/Downloads" = {
    device = "/dev/disk/by-uuid/18717cb4-49ac-40fa-95d4-29523a458dd0";
    fsType = "ext4";
  };

  fileSystems."/home/${username}/Videos" = {
    device = "/dev/disk/by-uuid/b67bbeab-58bc-4814-b5e3-08404e78b25e";
    fsType = "ext4";
  };

  fileSystems."/home/${username}/Pictures" = {
    device = "/dev/disk/by-uuid/a31bfe7e-cc17-4bd2-af74-ae5de9be35d3";
    fsType = "ext4";
  };

  fileSystems."/home/${username}/Music" = {
    device = "//192.168.3.2/share/imxyy_soope_/Music";
    fsType = "cifs";
    options = [
      "username=nas"
      "password=nasshare"
      "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
      "nodev"
      "nofail"
      "uid=1000"
      "gid=100"
      "vers=3"
      "rw"
    ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 32 * 1024;
    }
  ];

  networking.useDHCP = lib.mkDefault false;

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
}
