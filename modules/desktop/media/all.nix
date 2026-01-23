{ config, lib, ... }:
let
  cfg = config.my.desktop.media.all;
in
{
  options.my.desktop.media.all = {
    enable = lib.mkEnableOption "all desktop media things";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.media = {
      mpv.enable = true;
      loupe.enable = true;
      thunderbird.enable = true;
      vlc.enable = true;
      splayer.enable = true;
      spotify.enable = true;
      spotube.enable = true;
    };
  };
}
