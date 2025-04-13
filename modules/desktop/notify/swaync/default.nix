{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "swaync";
  packagePath = [ "swaynotificationcenter" ];
  optionPath = [
    "desktop"
    "notify"
    "swaync"
  ];
  extraConfig = {
    my.home = {
      programs.niri.settings.binds."Mod+End".action.spawn = [
        "swaync-client"
        "-t"
        "-sw"
      ];
      xdg.configFile."swaync" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
