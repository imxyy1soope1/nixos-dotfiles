{ pkgs, ... }: {
  nixpkgs.config = {
    programs.npm.npmrc = ''
      prefix = ''${HOME}/.npm-global
    '';
  };
  home.packages = with pkgs; [
    python3
    lua
    gcc
    gnumake
    cmake
    go
    nodejs
    nodePackages.npm
    github-cli # gh
  ];
  programs.zsh.initExtraFirst = ''
    source ${./github-cli-comp}
  '';
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
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
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
