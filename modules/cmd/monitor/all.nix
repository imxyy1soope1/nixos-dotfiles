{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all command line monitor tools";
  optionPath = [
    "cmd"
    "monitor"
    "all"
  ];
  config' = {
    my.cmd.monitor = {
      btop.enable = true;
    };
  };
}
