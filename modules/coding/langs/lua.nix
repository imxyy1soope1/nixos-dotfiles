{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "lua";
  optionPath = [
    "coding"
    "langs"
    "lua"
  ];
  config' = {
    my.home.home.packages = with pkgs; [
      luajit
    ];
  };
}
