{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all desktop gaming things";
  optionPath = [
    "desktop"
    "gaming"
    "all"
  ];
  config' = {
    my.desktop.gaming = {
      minecraft.enable = true;
      steam.enable = true;
    };
  };
}
