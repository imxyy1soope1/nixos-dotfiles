{ pkgs, ... }:
{
  nixpkgs = {
    config = {
      programs.npm.npmrc = ''
        prefix = ''${HOME}/.npm-global
        home=https://npm.taobao.org
        registry=https://registry.npm.taobao.org/
        sass_binary_site="https://npm.taobao.org/mirrors/node-sass/"
        phantomjs_cdnurl="http://cnpmjs.org/downloads"
        ELECTRON_MIRROR="https://mirrors.huaweicloud.com/electron/"
        sqlite3_binary_host_mirror="https://foxgis.oss-cn-shanghai.aliyuncs.com/"
        profiler_binary_host_mirror="https://npm.taobao.org/mirrors/node-inspector/"
        chromedriver_cdnurl="https://npm.taobao.org/mirrors/chromedriver"
        puppeteer_download_host = https://npm.taobao.org/mirrors
        selenium_cdnurl=http://npm.taobao.org/mirrors/selenium
        node_inspector_cdnurl=https://npm.taobao.org/mirrors/node-inspector
      '';
    };
  };
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
