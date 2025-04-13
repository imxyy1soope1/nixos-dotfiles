{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "minecraft";
  optionPath = [
    "desktop"
    "gaming"
    "minecraft"
  ];
  config' = {
    my.home.home.packages = with pkgs; [
      hmcl

      openjdk21
    ];

    my.persist.homeDirs = [
      ".minecraft"
      ".local/share/hmcl"
    ];
  };
}
