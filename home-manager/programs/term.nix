{ config, pkgs, ... }:

{
  # Alacritty
  programs.alacritty.enable = true;
  xdg.configFile.alacritty = ./alacritty;


}
