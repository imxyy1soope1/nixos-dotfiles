{pkgs, ...}: {
  programs.btop.enable = true;
  xdg.configFiles."btop" = {
    source = ./btop;
    recursive = true;
  };
  home.packages = with pkgs; [
    tmux
  ];
  xdg.configFiles."tmux/tmux.conf".source = ./tmux.conf;
}
