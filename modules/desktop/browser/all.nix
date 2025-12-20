{ config, lib, ... }:
let
  cfg = config.my.desktop.browser.all;
in
{
  options.my.desktop.browser.all = {
    enable = lib.mkEnableOption "all desktop browsers";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.browser = {
      firefox.enable = true;
      chromium.enable = true;
      zen.enable = true;
    };
  };
}
