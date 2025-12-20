{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.shotwell;
in
{
  options.my.desktop.media.shotwell = {
    enable = lib.mkEnableOption "shotwell";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.shotwell ];
  };
}
