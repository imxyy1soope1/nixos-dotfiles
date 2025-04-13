{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "spotify";
  packagePath = [ "spotify" ];
  optionPath = [
    "desktop"
    "media"
    "spotify"
  ];
}
