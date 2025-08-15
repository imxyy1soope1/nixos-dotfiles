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
    my.home.home.packages = with pkgs; [
      wineWayland
      proton-ge-custom
      bottles
    ];
    my.persist.homeDirs = [
      ".local/share/bottles"
    ];
  };
}
