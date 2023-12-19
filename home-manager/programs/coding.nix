{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    python3
    lua
    gcc
    gnumake
    cmake
    go
    nodejs
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      nodejs
      nodePackages.npm

      cargo
      rustc

      lua

      nil
    ];
  };
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
