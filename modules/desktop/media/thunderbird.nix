{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.thunderbird;
in
{
  options.my.desktop.media.thunderbird = {
    enable = lib.mkEnableOption "thunderbird";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.thunderbird ];
    my.persist.homeDirs = [
      ".thunderbird"
    ];
  };
}
