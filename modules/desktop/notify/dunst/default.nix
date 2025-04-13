{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "dunst";
  packagePath = [ "dunst" ];
  optionPath = [
    "desktop"
    "notify"
    "dunst"
  ];
  extraConfig = {
    my.home.xdg.configFile."dunst/dunstrc".source = ./dunstrc;
  };
}
