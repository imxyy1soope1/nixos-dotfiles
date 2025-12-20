{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.spotube;
in
{
  options.my.desktop.media.spotube = {
    enable = lib.mkEnableOption "spotube";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.spotube ];
    my.persist.homeDirs = [
      ".local/share/oss.krtirtho.spotube"
    ];
  };
}
