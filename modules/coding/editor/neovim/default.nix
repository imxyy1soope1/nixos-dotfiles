{
  config,
  lib,
  pkgs,
  impure,
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
      xdg.configFile."nvim".source = impure.mkImpureLink ./nvim;
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        extraPackages = with pkgs; [
          gcc # treesitter

          ripgrep # telescope

          vscode-json-languageserver
          typos-lsp
        ];
      };
    };
    my.persist.homeDirs = [
      ".local/share/nvim"
    ];
  };
}
