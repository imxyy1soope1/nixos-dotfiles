{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "neovim";
  optionPath = [
    "coding"
    "editor"
    "neovim"
  ];
  extraConfig = {
    my.home = {
      xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
      xdg.configFile."nvim/lua" = {
        source = ./nvim/lua;
        recursive = true;
      };
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        extraPackages = with pkgs; [
          gcc # treesitter

          ripgrep # telescope
        ];
      };
    };
    my.persist.homeDirs = [
      ".local/share/nvim"
    ];
  };
}
