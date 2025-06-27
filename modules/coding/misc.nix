{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "misc";
  optionPath = [
    "coding"
    "misc"
  ];
  config' = {
    my.home = {
      home.packages = with pkgs; [
        gnumake
        github-cli # gh
      ];
      programs.direnv.enable = true;
    };
    my.persist.homeDirs = [
      ".local/share/direnv"
    ];
  };
}
