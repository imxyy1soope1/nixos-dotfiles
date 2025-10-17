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
    my.hm.home.packages = with pkgs; [
      openjdk25
      java-language-server
    ];
  };
}
