{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.c;
in
{
  options.my.coding.langs.c = {
    enable = lib.mkEnableOption "c";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      gcc
      (lib.hiPrio clang)
      clang-tools
      cmake
    ];
  };
}
