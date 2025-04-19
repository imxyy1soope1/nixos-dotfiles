{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all command line monitor tools";
  optionPath = [
    "cli"
    "monitor"
    "all"
  ];
  config' = {
    my.cli.monitor = {
      btop.enable = true;
    };
  };
}
