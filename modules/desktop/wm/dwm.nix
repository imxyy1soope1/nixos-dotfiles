{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "dwm";
  packagePath = [ "dwm" ];
  optionPath = [
    "desktop"
    "wm"
    "dwm"
  ];
}
