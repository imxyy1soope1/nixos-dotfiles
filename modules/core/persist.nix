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
      requires = [ "initrd-root-device.target" ];
      after = [ "initrd-root-device.target" "local-fs-pre.target" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        set -euo pipefail

        mkdir -p /btrfs_tmp
        trap 'umount /btrfs_tmp || true' EXIT
        mount '${cfg.btrfs.device}' -o subvol=/ /btrfs_tmp

        root=/btrfs_tmp/${cfg.btrfs.rootSubvol}
        mkdir -p /btrfs_tmp/old_roots

        if [ -d "$root" ]; then
          timestamp=$(TZ=${if config.time.timeZone == null then "UTC" else config.time.timeZone} \
            date -d "@$(stat -c %Y "$root")" '+%Y-%m-%d_%H:%M:%S')
          mv "$root" "/btrfs_tmp/old_roots/$timestamp"
        fi

        btrfs subvolume create "$root"

        for i in $(find /btrfs_tmp/old_roots -mindepth 1 -maxdepth 1 -mtime +14); do
          btrfs subvolume delete -R "$i"
        done
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
