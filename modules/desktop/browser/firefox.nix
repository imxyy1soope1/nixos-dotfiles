{ config, lib, ... }:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "firefox";
  optionPath = [
    "desktop"
    "browser"
    "firefox"
  ];
  extraConfig = {
    my.persist.homeDirs = [
      ".mozilla"
    ];
  };
}
