{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.screencast.obs-studio;
in
{
  options.my.desktop.screencast.obs-studio = {
    enable = lib.mkEnableOption "obs-studio";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
        ];
      })
    ];
    my.persist.homeDirs = [
      ".config/obs-studio"
    ];
  };
}
