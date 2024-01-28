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
      ];
    };
  };
}
