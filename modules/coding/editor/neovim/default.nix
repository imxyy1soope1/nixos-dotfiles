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
        package = pkgs.neovim-unwrapped.overrideAttrs {
          treesitter-parsers = { };
        };
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        extraPackages = with pkgs; [
          gcc
          gnumake

          pyright

          clang-tools

          rust-analyzer
          pest-ide-tools

          nixd

          gotools
          gopls

          stylua
          lua-language-server

          nodePackages.vscode-langservers-extracted
          nodePackages.typescript-language-server
          vue-language-server
          typescript
          nodejs

          ripgrep
        ];
      };
    };
  };
}
