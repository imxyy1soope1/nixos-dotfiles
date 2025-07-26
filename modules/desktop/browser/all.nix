{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all desktop browsers";
  optionPath = [
    "desktop"
    "browser"
    "all"
  ];
  config' = {
    my.desktop.browser = {
      firefox.enable = true;
      chromium.enable = true;
      zen.enable = true;
    };
  };
}
