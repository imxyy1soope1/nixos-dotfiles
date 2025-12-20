{ config, lib, ... }:
let
  cfg = config.my.desktop.browser.firefox;
in
{
  options.my.desktop.browser.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf cfg.enable {
    my.hm.programs.firefox.enable = true;
    my.persist.homeDirs = [
      ".mozilla"
    ];
  };
}
