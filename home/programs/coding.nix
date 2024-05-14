{ pkgs, ... }:
{
  home.file.".npmrc".text = ''
    prefix = ''${HOME}/.npm-global
  '';
  home.file.".cargo/config.toml".text = ''
    [source.crates-io]
    replace-with = 'rsproxy-sparse'

    [source.rsproxy-sparse]
    registry = "sparse+https://rsproxy.cn/index/"

    [net]
    git-fetch-with-cli = true
  '';

  home.packages = with pkgs; [
    lua

    python3

    gnumake

    gcc
    cmake

    go

    cargo
    rustc
    rustfmt
    clippy
    evcxr # rust repl

    nodejs
    nodePackages.npm

    neovide

    github-cli # gh
  ];
  programs.direnv.enable = true;
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
    package = pkgs.neovim-unwrapped.override {
      treesitter-parsers = { };
    };
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      nodePackages.pyright

      clang-tools

      rust-analyzer
      nil
      # nixd

      gotools
      gopls

      stylua
      lua-language-server

      nodePackages.vscode-langservers-extracted
      nodePackages.typescript-language-server

      ripgrep
    ];
  };
}
