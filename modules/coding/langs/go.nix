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
    my.hm.home.packages = with pkgs; [
      gotools
      gopls
    ];
    my.persist.homeDirs = [
      "go"
    ];
  };
}
