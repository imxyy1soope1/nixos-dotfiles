{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "ffmpeg";
  packagePath = [ "ffmpeg" ];
  optionPath = [
    "cli"
    "media"
    "ffmpeg"
  ];
}
