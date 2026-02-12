{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.gaming.minecraft;
in
{
  options.my.desktop.gaming.minecraft = {
    enable = lib.mkEnableOption "minecraft";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.hmcl
    ];

    my.persist.homeDirs = [
      ".minecraft"
      ".local/share/hmcl"
      ".hmcl"
    ];
  };
}
