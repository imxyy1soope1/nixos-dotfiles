{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.vlc;
in
{
  options.my.desktop.media.vlc = {
    enable = lib.mkEnableOption "vlc";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.vlc ];
  };
}
