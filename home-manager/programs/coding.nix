{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python
    lua
    gcc
    make
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
