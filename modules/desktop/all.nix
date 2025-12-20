{ config, lib, ... }:
let
  cfg = config.my.desktop.all;
in
{
  options.my.desktop.all = {
    enable = lib.mkEnableOption "all desktop things";
  };

  config = lib.mkIf cfg.enable {
    my.desktop = {
      browser.all.enable = true;
      gaming.all.enable = true;
      media.all.enable = true;
      screencast.all.enable = true;
      terminal.all.enable = true;
      wm.all.enable = true;
      style.enable = true;
      wine.enable = true;
    };
  };
}
