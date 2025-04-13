{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "cage";
  packagePath = [ "cage" ];
  optionPath = [
    "desktop"
    "wm"
    "cage"
  ];
}
