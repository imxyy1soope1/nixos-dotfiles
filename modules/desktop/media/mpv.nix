{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.mpv;
in
{
  options.my.desktop.media.mpv = {
    enable = lib.mkEnableOption "mpv";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.mpv ];
  };
}
