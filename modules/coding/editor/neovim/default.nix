{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.editor.neovim;
in
{
  options.my.coding.editor.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
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

          typos-lsp
        ];
      };
    };
    my.persist.homeDirs = [
      ".local/share/nvim"
    ];
  };
}
