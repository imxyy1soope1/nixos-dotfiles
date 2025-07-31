{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "java";
  optionPath = [
    "coding"
    "langs"
    "java"
  ];
  config' = {
    my.home.home.packages = with pkgs; [
      openjdk24
    ];
  };
}
