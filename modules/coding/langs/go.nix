{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "go";
  packagePath = [ "go" ];
  optionPath = [
    "coding"
    "langs"
    "go"
  ];
  extraConfig = {
    my.persist.homeDirs = [
      "go"
    ];
  };
}
