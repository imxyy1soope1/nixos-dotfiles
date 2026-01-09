{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.splayer;
in
{
  options.my.desktop.media.splayer = {
    enable = lib.mkEnableOption "splayer";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.splayer ];
    my.persist.homeDirs = [
      ".config/SPlayer"
    ];
  };
}
