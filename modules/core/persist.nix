{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.my.persist;
in
{
  options.my.persist = {
    enable = lib.mkEnableOption "persist";
    btrfs = lib.mkOption {
      type = lib.types.submodule (
        { ... }:
        {
          options = {
            device = lib.mkOption {
              type = lib.types.str;
            };
            zstdCompress = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
            persistSubvol = lib.mkOption {
              type = lib.types.str;
            };
            rootSubvol = lib.mkOption {
              type = lib.types.str;
              default = "root";
            };
            mountPoint = lib.mkOption {
              type = lib.types.str;
              default = "/nix/persist";
              example = lib.literalExpression ''
                "/persistent"
              '';
            };
          };
        }
      );
    };
    homeDirs = lib.mkOption {
      default = [ ];
      example = lib.literalExpression ''
        [
          ".minecraft"
          ".cargo"
        ]
      '';
      description = lib.mdDoc ''
        HomeManager persistent dirs.
      '';
    };
    nixosDirs = lib.mkOption {
      default = [ ];
      example = lib.literalExpression ''
        [
          "/root"
          "/var"
        ]
      '';
      description = lib.mdDoc ''
        NixOS persistent dirs.
      '';
    };
    homeFiles = lib.mkOption {
      default = [ ];
      example = lib.literalExpression ''
        [
          ".hmcl.json"
        ]
      '';
      description = lib.mdDoc ''
        Persistent files.
      '';
    };
    nixosFiles = lib.mkOption {
      default = [ ];
      example = lib.literalExpression ''
        [
          "/etc/machine-id"
        ]
      '';
      description = lib.mdDoc ''
        Persistent files.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems.${cfg.btrfs.mountPoint} = {
      device = cfg.btrfs.device;
      fsType = "btrfs";
      options = [
        "subvol=${cfg.btrfs.persistSubvol}"
      ]
      ++ lib.optionals cfg.btrfs.zstdCompress [
        "compress=zstd"
      ];
      neededForBoot = true;
    };
    fileSystems."/" = {
      device = cfg.btrfs.device;
      fsType = "btrfs";
      options = [
        "subvol=${cfg.btrfs.rootSubvol}"
      ]
      ++ lib.optionals cfg.btrfs.zstdCompress [
        "compress=zstd"
      ];
    };

    boot.initrd.systemd.services.wipe-root = {
      description = "Rollback BTRFS rootfs";
      wantedBy = [ "initrd.target" ];
      before = [ "sysroot.mount" ];
      after = [ "initrd-root-device.target" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        mkdir -p /btrfs_tmp
        mount ${cfg.btrfs.device} /btrfs_tmp
        mkdir -p /btrfs_tmp/old_roots

        if [ -e /btrfs_tmp/root ]; then
          timestamp=$(date -d "@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S" 2>/dev/null || date "+%Y-%m-%d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
          IFS=$(printf '\n')
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +14); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/${cfg.btrfs.rootSubvol}
        umount /btrfs_tmp
      '';
    };

    programs.fuse.userAllowOther = true;
    environment.persistence.${cfg.btrfs.mountPoint} = {
      hideMounts = true;
      directories = cfg.nixosDirs;
      files = cfg.nixosFiles;
      users.${username} = {
        files = cfg.homeFiles;
        directories = cfg.homeDirs;
      };
    };
  };
}
