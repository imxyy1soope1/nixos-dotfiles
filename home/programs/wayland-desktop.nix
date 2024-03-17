{ inputs, pkgs, system, ... }: {
  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    swaybg
    wl-clipboard
    cliphist
    gnome.zenity
    swaynotificationcenter
    hyprshot
    cage
    inputs.hyprsome.packages.${system}.default
  ];
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
  xdg.configFile."swaync" = {
    source = ./swaync;
    recursive = true;
  };
  programs.zsh.shellAliases = {
    cageterm = "cage -m last -s -- alacritty --config-file ~/.config/alacritty/alacritty-tty.toml";
    cagefoot = "cage -m last -s -- foot --font=monospace:size=20";
  };
}
