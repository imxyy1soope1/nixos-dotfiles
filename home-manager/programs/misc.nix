{ pkgs, ... }: {
  programs.btop.enable = true;
  xdg.configFile."btop" = {
    source = ./btop;
    recursive = true;
  };
  home.packages = with pkgs; [
    lsd
    neofetch
    fzf
    bat
    ripgrep

    aria2
    socat

    nix-output-monitor

    tmux

    trash-cli
  ];
  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  programs.zsh.shellAliases = {
    rrm = "coreutils --coreutils-prog=rm";
    rm = "trash-put";
  };
}
