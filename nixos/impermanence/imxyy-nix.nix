{ impermanence, username, ... }: {
  imports = [
    impermanence.nixosModules.impermanence
  ];
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/root"
      "/var"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.${username} = {
      directories = [
        ".minecraft"
        ".mozilla"
        ".hyprland"
        ".ssh"
        "bin"
        "go"
        "workspace"

        # ".cache"
        ".local/state"
        ".local/share/dooit"
        ".local/share/hmcl"
        ".local/share/nvim"
        ".local/share/Trash"
        ".local/share/treesitter"
        ".config/gh"
        ".config/pulse"
        ".config/go-musicfox/db"
        ".config/tmux/plugins"
      ];
      files = [
        # ".local/state/fzf_history"
        # ".local/state/zsh_history"
        # ".local/state/zlua"
        ".config/go-musicfox/musicfox.log"
        ".config/go-musicfox/cookie"
      ];
    };
  };
}
