{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.media.ffmpeg;
in
{
  options.my.cli.media.ffmpeg = {
    enable = lib.mkEnableOption "ffmpeg";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.ffmpeg ];
  };
}
