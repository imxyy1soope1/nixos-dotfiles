{ config, lib, ... }:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "librewolf";
  optionPath = [
    "desktop"
    "browser"
    "librewolf"
  ];
  extraConfig = {
    my.persist.homeDirs = [
      ".librewolf"
    ];
  };
}
