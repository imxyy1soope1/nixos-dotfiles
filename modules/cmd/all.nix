{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all command line tools";
  optionPath = [
    "cmd"
    "all"
  ];
  config' = {
    my.cmd = {
      media.all.enable = true;
      misc.enable = true;
      monitor.all.enable = true;
      shell.all.enable = true;
    };
  };
}
