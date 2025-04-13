{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "spotube";
  packagePath = [ "spotube" ];
  optionPath = [
    "desktop"
    "media"
    "spotube"
  ];
}
