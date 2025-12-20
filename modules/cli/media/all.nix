{ config, lib, ... }:
let
  cfg = config.my.cli.media.all;
in
{
  options.my.cli.media.all = {
    enable = lib.mkEnableOption "all command line media tools";
  };

  config = lib.mkIf cfg.enable {
    my.cli.media = {
      go-musicfox.enable = true;
      ffmpeg.enable = true;
    };
  };
}
