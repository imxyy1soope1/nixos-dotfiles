{ config, lib, ... }:
let
  cfg = config.my.bluetooth;
in
{
  options.my.bluetooth = {
    enable = lib.mkEnableOption "default bluetooth settings";
  };

  config = lib.mkIf cfg.enable {
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
