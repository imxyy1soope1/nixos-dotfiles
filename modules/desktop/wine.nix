{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "wine";
  optionPath = [
    "desktop"
    "wine"
  ];
  config' = {
    my.hm.home.packages = with pkgs; [
      wine-wayland
      bottles
    ];
    my.persist.homeDirs = [
      ".local/share/bottles"
    ];
  };
}
