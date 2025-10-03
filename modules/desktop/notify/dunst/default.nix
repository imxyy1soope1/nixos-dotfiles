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
    my.hm.xdg.configFile."dunst/dunstrc".source = ./dunstrc;
  };
}
