{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all terminals";
  optionPath = [
    "desktop"
    "terminal"
    "all"
  ];
  config' = {
    my.desktop.terminal = {
      alacritty.enable = true;
      foot.enable = true;
      kitty.enable = true;
      ghostty.enable = true;
    };
  };
}
