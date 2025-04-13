{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all command line media tools";
  optionPath = [
    "cmd"
    "media"
    "all"
  ];
  config' = {
    my.cmd.media = {
      cava.enable = true;
      go-musicfox.enable = true;
      mpd.enable = true;
      ffmpeg.enable = true;
    };
  };
}
