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

          # Avoid bluetooth headset connection failure
          Experimental = true;
          FastConnectable = true;
          ControllerMode = "dual";
        };
      };
    };

    boot.extraModprobeConfig = ''
      options btusb enable_autosuspend=n
    '';
  };
}
