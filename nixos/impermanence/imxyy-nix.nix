{ impermanence, username, ... }: {
  imports = [
    impermanence.nixosModules.impermanence
  ];
  programs.fuse.userAllowOther = true;
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/v2raya"
      "/root"
      "/var"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.${username} = {
      files = [
        ".config/mpd/mpd.db" # requires bindfs
        ".hmcl.json"
      ];
    };
  };

  /* systemd.mounts = [
    {
      type = "btrfs";
      options = "compress=zstd";
      what = "/dev/nvme0n1p2";
      where = "/btrfs_tmp";
    }
    ];
    systemd.services.snap-persistent = {
    description = "/persistent backup";
    unitConfig.requiresMountsFor = "/btrfs_tmp";
    script = ''mkdir -p /btrfs_tmp/persistent_backups; btrfs subvolume snapshot -r /btrfs_tmp/persistent "/btrfs_tmp/persistent_backups/$(date '+%Y-%m-%-d_%H:%M:%S')"; umount /btrfs_tmp; rmdir /btrfs_tmp'';
    serviceConfig.Type = "oneshot";
    startAt = "weekly";
    };
    systemd.timers.snap-persistent = {
    timerConfig = {
      RandomizedDelaySec = "0";
      Persistent = true;
    };
  }; */
}
