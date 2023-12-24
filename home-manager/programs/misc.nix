{pkgs, ...}: {
  programs.btop.enable = true;
  xdg.configFile."btop" = {
    source = ./btop;
    recursive = true;
  };
  home.packages = with pkgs; [
    tmux
  ];
  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
}
