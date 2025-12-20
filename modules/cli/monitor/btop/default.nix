{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.monitor.btop;
in
{
  options.my.cli.monitor.btop = {
    enable = lib.mkEnableOption "btop";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.btop ];
    my.hm.xdg.configFile."btop" = {
      source = ./config;
      recursive = true;
    };
  };
}
