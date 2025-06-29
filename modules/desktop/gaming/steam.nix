{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "steam";
  optionPath = [
    "desktop"
    "gaming"
    "steam"
  ];
  config' = {
    programs.steam = {
      enable = true;
      package = pkgs.steam;
      extraPackages = with pkgs; [
        gamescope
      ];
    };
    my.persist.homeDirs = [
      ".local/share/Steam"
    ];
  };
}
