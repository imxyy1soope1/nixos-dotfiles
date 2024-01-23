{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.persistence."/persistent/home/imxyy" = {
    allowOther = true;
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
  };
}
