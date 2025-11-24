{
  config,
  lib,
  pkgs,
  ...
}:
let
  btrfs = "/dev/disk/by-uuid/c7889c5c-c5b6-4e3c-9645-dfd49c2e84d0";
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
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_stable;
  services.scx = {
    enable = true;
    scheduler = "scx_rusty";
  };
  boot.extraModulePackages = [ ];
  boot.tmp.useTmpfs = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    package = pkgs.zfs_unstable;
    extraPools = [ "data" ];
    forceImportRoot = false;
  };
  services.zfs.autoScrub.enable = true;
  services.btrfs.autoScrub.enable = true;
  networking.hostId = "10ca95b4";

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
    options = [
      "compress=zstd"
      "subvol=nix"
    ];
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
    device = "/dev/disk/by-uuid/32AA-2998";
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
