{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.spotify;
in
{
  options.my.desktop.media.spotify = {
    enable = lib.mkEnableOption "spotify";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.spotify ];
  };
}
