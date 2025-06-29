{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "obs-studio";
  optionPath = [
    "desktop"
    "screencast"
    "obs-studio"
  ];
  config' = {
    my.home.home.packages = with pkgs; [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
        ];
      })
    ];
    my.persist.homeDirs = [
      ".config/obs-studio"
    ];
  };
}
