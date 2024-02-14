{ pkgs, ... }:
{
  home.file.".npmrc".text = ''
    prefix = ''${HOME}/.npm-global
  '';
  programs.zsh.sessionVariables.PATH = "$HOME/.npm-global/bin:$PATH";
  home.packages = with pkgs; [
    # jupyter

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
    /*(fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])*/
    evcxr # rust repl

    nodejs
    nodePackages.npm

    neovide

    github-cli # gh
  ];
  programs.git.lfs.enable = true;
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
    # package = pkgs.neovim-nightly;
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

      llvmPackages.clang-unwrapped

      rust-analyzer
      /*rust-analyzer-nightly
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])*/

      nil
      rnix-lsp
      # nixd

      gotools
      gopls

      stylua
      lua-language-server

      nodePackages.vscode-langservers-extracted
      nodePackages.typescript-language-server

      marksman

      ripgrep
    ];
  };
}
