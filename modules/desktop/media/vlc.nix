{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "vlc";
  packagePath = [ "vlc" ];
  optionPath = [
    "desktop"
    "media"
    "vlc"
  ];
}
