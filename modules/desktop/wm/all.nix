{
  config,
  lib,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "all window managers";
  optionPath = [
    "desktop"
    "wm"
    "all"
  ];
  config' = {
    my.desktop.wm = {
      cage.enable = true;
      niri.enable = true;
    };
  };
}
