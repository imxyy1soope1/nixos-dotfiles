{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.cine;
  desktop = [ "io.github.diegopvlk.Cine.desktop" ];
in
{
  options.my.desktop.media.cine = {
    enable = lib.mkEnableOption "cine";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.cine ];
    my.xdg.defaultApplications = {
      "audio/*" = desktop;
      "video/*" = desktop;
    };
  };
}
