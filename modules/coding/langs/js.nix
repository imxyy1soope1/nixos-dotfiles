{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.js;
in
{
  options.my.coding.langs.js = {
    enable = lib.mkEnableOption "js";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      home.packages = with pkgs; [
        nodejs
        pnpm
        typescript

        nodePackages.typescript-language-server
        vue-language-server
      ];
      home.file.".npmrc".text = ''
        prefix = ''${HOME}/.npm-global
        registry = https://registry.npmmirror.com
      '';
      programs.zsh.initContent = lib.mkAfter ''
        export PATH=$PATH:$HOME/.npm-global/bin
      '';
    };
    my.persist.homeDirs = [
      ".npm"
      ".npm-global"
      ".local/share/pnpm"
    ];
  };
}
