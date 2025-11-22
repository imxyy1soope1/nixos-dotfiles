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
    my.hm.home.packages = with pkgs; [
      gcc
      (lib.hiPrio clang)
      clang-tools
      cmake
    ];
  };
}
