{
  config,
  lib,
  pkgs,
  impure,
  ...
}:
let
  cfg = config.my.coding.editor.neovim;
  desktop = [ "nvim.desktop" ];
in
{
  options.my.coding.editor.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
    # workaround
    environment.sessionVariables.EDITOR = "nvim";
    my.hm = {
      xdg.configFile."nvim".source = impure.mkImpureLink ./nvim;
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withPython3 = false;
        withRuby = false;
        sideloadInitLua = true;
        extraPackages = with pkgs; [
          # treesitter
          tree-sitter
          gnutar
          curl
          gcc

          ripgrep # telescope

          # language servers
          vscode-json-languageserver
          vscode-langservers-extracted
          typos-lsp

          # render-markdown.nvim
          python3Packages.pylatexenc
        ];
      };
    };
    my.persist.homeDirs = [
      ".local/share/nvim"
    ];
    my.xdg.defaultApplications = {
      "text/*" = desktop;
      "application/json" = desktop;
      "text/xml" = desktop;
      "application/xml" = desktop;
      "application/xhtml+xml" = desktop;
      "application/xhtml_xml" = desktop;
      "application/rdf+xml" = desktop;
      "application/rss+xml" = desktop;
      "application/x-extension-htm" = desktop;
      "application/x-extension-html" = desktop;
      "application/x-extension-shtml" = desktop;
      "application/x-extension-xht" = desktop;
      "application/x-extension-xhtml" = desktop;
    };
  };
}
