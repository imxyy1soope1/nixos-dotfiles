{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python3
    lua
    gcc
    gnumake
    cmake
    go
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
