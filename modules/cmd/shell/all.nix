{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all shells";
  optionPath = [
    "cmd"
    "shell"
    "all"
  ];
  config' = {
    my.cmd.shell = {
      zsh.enable = true;
    };
  };
}
