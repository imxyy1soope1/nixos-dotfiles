{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all screencast tools";
  optionPath = [
    "desktop"
    "screencast"
    "all"
  ];
  config' = {
    my.desktop.screencast = {
      obs-studio.enable = true;
    };
  };
}
