{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "shotwell";
  packagePath = [ "shotwell" ];
  optionPath = [
    "desktop"
    "media"
    "shotwell"
  ];
}
