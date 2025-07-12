{
  config,
  lib,
  pkgs,
  username,
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
	"nvme" "xhci_pci" "thunderbolt" "uas" "sd_mod"
      ];
      verbose = false;
    };

    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
    kernelModules = [ "kvm-amd" ];

    tmp.useTmpfs = true;
    kernel.sysctl = {
      "fs.file-max" = 9223372036854775807;
    };
  };
  services.scx.enable = true;

  fileSystems."/" = {
    device = btrfs;
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=root"
    ];
  };

  fileSystems."/nix" = {
    device = btrfs;
    fsType = "btrfs";
    options = [ "compress=zstd" "subvol=nix" ];
  };

  my.persist.location = "/nix/persist";
  fileSystems."/nix/persist" = {
    device = btrfs;
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=persist"
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
