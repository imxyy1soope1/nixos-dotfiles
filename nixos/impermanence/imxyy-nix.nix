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
    /* users.${username} = {
      directories = [
        ".minecraft"
        ".mozilla"
        ".thunderbird"
        ".hyprland"
        ".ssh"
        "bin"
        "go"
        "workspace"

        ".cache"
        ".local/state"
        ".local/share/dooit"
        ".local/share/hmcl"
        ".local/share/nvim"
        ".local/share/shotwell"
        ".local/share/Steam"
        ".local/share/Trash"
        ".local/share/cheat.sh"
        ".local/share/Kingsoft"
        ".config/Kingsoft"
        ".config/dconf"
        ".config/gh"
        ".config/pulse"
        ".config/microsoft-edge"
        ".config/go-musicfox/db"
        ".config/tmux/plugins"
        ".config/pip"
        ".config/QQ"
        ".config/Element"
      ];
      files = [
        ".hmcl.json"

        ".config/go-musicfox/musicfox.log"
        ".config/go-musicfox/cookie"
        ".config/mpd/mpd.db"
      ];
    }; */
  };
}
