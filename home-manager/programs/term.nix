{ config, pkgs, ... }:

{
  # Alacritty
  programs.alacritty.enable = true;
  xdg.configFile."alacritty" = {
    source = ./alacritty;
    recursive = true;
  };
}
