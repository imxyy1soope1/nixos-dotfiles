{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all desktop things";
  optionPath = [
    "desktop"
    "all"
  ];
  config' = {
    my.desktop = {
      browser.all.enable = true;
      gaming.all.enable = true;
      media.all.enable = true;
      notify.all.enable = true;
      screencast.all.enable = true;
      terminal.all.enable = true;
      wm.all.enable = true;
      style.enable = true;
      quickshell.enable = true;
    };
  };
}
