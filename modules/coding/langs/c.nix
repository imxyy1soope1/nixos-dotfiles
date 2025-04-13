{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "c";
  optionPath = [
    "coding"
    "langs"
    "c"
  ];
  config' = {
    my.home.home.packages = with pkgs; [
      gcc
      clang-tools
      cmake
    ];
  };
}
