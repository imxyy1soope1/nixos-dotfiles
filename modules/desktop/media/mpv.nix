{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "mpv";
  packagePath = [ "mpv" ];
  optionPath = [
    "desktop"
    "media"
    "mpv"
  ];
}
