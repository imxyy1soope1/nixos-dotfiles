{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all command line media tools";
  optionPath = [
    "cli"
    "media"
    "all"
  ];
  config' = {
    my.cli.media = {
      cava.enable = true;
      go-musicfox.enable = true;
      mpd.enable = true;
      ffmpeg.enable = true;
    };
  };
}
