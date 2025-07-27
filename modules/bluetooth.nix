{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default bluetooth settings";
  optionPath = [ "bluetooth" ];
  config' = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Disable = "HeadSet";
          MultiProfile = "multiple";
        };
      };
    };
  };
}
