{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # To prevent from generating config
  };
  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;
  };
  programs.wofi.enable = true;
  xdg.configFile."wofi" = {
    source = ./wofi;
    recursive = true;
  };
  programs.waybar.enable = true;
  xdg.configFile."waybar" = {
    source = ./waybar;
    recursive = true;
  };
  home.packages = with pkgs; [
    swaynotificationcenter
    cage
  ];
  xdg.configFile."swaync" = {
    source = ./swaync;
    recursive = true;
  };
  programs.zsh.shellAliases = {
    # cageterm = "cage -m last -s -- alacritty --config-file ~/.config/alacritty/alacritty-tty.toml";
    cageterm = "cage -m last -s -- alacritty --config-file ~/.config/alacritty/alacritty-tty.yml";
  };
}
