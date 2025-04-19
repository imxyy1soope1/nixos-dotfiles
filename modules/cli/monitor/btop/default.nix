{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "btop";
  packagePath = [ "btop" ];
  optionPath = [
    "cli"
    "monitor"
    "btop"
  ];
  extraConfig = {
    my.home.xdg.configFile."btop" = {
      source = ./config;
      recursive = true;
    };
  };
}
