{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all command line tools";
  optionPath = [
    "cli"
    "vcs"
    "all"
  ];
  config' = {
    my.cli.vcs = {
      git.enable = true;
      jj.enable = true;
    };
  };
}
