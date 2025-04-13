{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "thunderbird";
  packagePath = [ "thunderbird" ];
  optionPath = [
    "desktop"
    "media"
    "thunderbird"
  ];
  extraConfig = {
    my.persist.homeDirs = [
      ".thunderbird"
    ];
  };
}
