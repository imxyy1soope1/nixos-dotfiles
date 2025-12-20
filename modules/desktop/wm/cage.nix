{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.wm.cage;
in
{
  options.my.desktop.wm.cage = {
    enable = lib.mkEnableOption "cage";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.cage ];
  };
}
