{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.lua;
in
{
  options.my.coding.langs.lua = {
    enable = lib.mkEnableOption "lua";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      luajit
      stylua
      lua-language-server
    ];
  };
}
