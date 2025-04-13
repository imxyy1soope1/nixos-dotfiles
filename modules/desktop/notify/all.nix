{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all desktop notify tools";
  optionPath = [
    "desktop"
    "notify"
    "all"
  ];
  config' = {
    my.desktop.notify = {
      dunst.enable = true;
      swaync.enable = true;
    };
  };
}
