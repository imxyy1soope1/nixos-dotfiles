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
    my.home.home.packages = [
      pkgs.hmcl
    ];

    my.persist.homeDirs = [
      ".minecraft"
      ".local/share/hmcl"
    ];
    my.persist.homeFiles = [
      ".hmcl.json"
    ];
  };
}
