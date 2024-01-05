{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  # home.persistence."/persistent/home/imxyy" = {
  #   allowOther = true;
  #   directories = [
  #     ".minecraft"
  #     ".mozilla"
  #     ".hyprland"
  #     ".ssh"
  #     "bin"
  #     "go"
  #     "workspace"
  #
  #     ".local/share/dooit"
  #     ".local/share/hmcl"
  #     ".local/share/nvim"
  #     ".local/share/Trash"
  #     ".local/share/treesitter"
  #     ".config/gh"
  #     ".config/pulse"
  #     ".config/go-musicfox/db"
  #   ];
  #   files = [
  #     ".local/state/fzf_history"
  #     ".local/state/zsh_history"
  #     ".local/state/zlua"
  #     ".config/go-musicfox/musicfox.log"
  #     ".config/go-musicfox/cookie"
  #   ];
  # };
}
