{ lib, pkgs, ... }:
{
  nixpkgs = {
    config = {
      programs.npm.npmrc = ''
        prefix = ''${HOME}/.npm-global
      '';
    };
    overlays = [
      # no default treesitter parser
      (final: prev: {
        neovim-nightly = prev.neovim-nightly.override {
          treesitter-parsers = lib.mkForce { };
        };
      })
    ];
  };
  home.packages = with pkgs; [
    lua

    python3

    gnumake

    gcc
    cmake

    go

    cargo
    rustc

    nodejs
    nodePackages.npm

    github-cli # gh
  ];
  programs.zsh.initExtraFirst = ''
    source ${./github-cli-comp}
  '';
  imports = [
    ./nvim/.luarc.json.nix
  ];
  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua" = {
    source = ./nvim/lua;
    recursive = true;
  };
  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      nodePackages.pyright

      llvmPackages.clang-unwrapped

      rust-analyzer
      cargo
      rustc

      nil
      rnix-lsp
      # nixd

      gotools
      gopls

      stylua
      lua-language-server

      nodePackages.vscode-langservers-extracted

      ripgrep
    ];
  };
}
