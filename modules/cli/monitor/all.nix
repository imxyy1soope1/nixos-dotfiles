{ config, lib, ... }:
let
  cfg = config.my.cli.monitor.all;
in
{
  options.my.cli.monitor.all = {
    enable = lib.mkEnableOption "all command line monitor tools";
  };

  config = lib.mkIf cfg.enable {
    my.cli.monitor = {
      btop.enable = true;
    };
  };
}
