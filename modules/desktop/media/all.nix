{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all desktop media things";
  optionPath = [
    "desktop"
    "media"
    "all"
  ];
  config' = {
    my.desktop.media = {
      mpv.enable = true;
      shotwell.enable = true;
      thunderbird.enable = true;
      vlc.enable = true;
      spotify.enable = true;
      spotube.enable = true;
    };
  };
}
