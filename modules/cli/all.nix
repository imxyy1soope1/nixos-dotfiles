{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all command line tools";
  optionPath = [
    "cli"
    "all"
  ];
  config' = {
    my.cli = {
      media.all.enable = true;
      misc.enable = true;
      monitor.all.enable = true;
      shell.all.enable = true;
    };
  };
}
