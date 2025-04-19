{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all shells";
  optionPath = [
    "cli"
    "shell"
    "all"
  ];
  config' = {
    my.cli.shell = {
      zsh.enable = true;
    };
  };
}
