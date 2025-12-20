{ config, lib, ... }:
let
  cfg = config.my.desktop.gaming.all;
in
{
  options.my.desktop.gaming.all = {
    enable = lib.mkEnableOption "all desktop gaming things";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.gaming = {
      minecraft.enable = true;
      steam.enable = true;
    };
  };
}
