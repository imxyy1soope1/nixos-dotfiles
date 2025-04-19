{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "cava";
  packagePath = [ "cava" ];
  optionPath = [
    "cli"
    "media"
    "cava"
  ];
  extraConfig = {
    my.home.xdg.configFile."cava" = {
      source = ./config;
      recursive = true;
    };
  };
}
