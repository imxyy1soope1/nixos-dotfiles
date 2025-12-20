{ config, lib, ... }:
let
  cfg = config.my.desktop.screencast.all;
in
{
  options.my.desktop.screencast.all = {
    enable = lib.mkEnableOption "all screencast tools";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.screencast = {
      obs-studio.enable = true;
    };
  };
}
