{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.nautilus;
in
{
  options.my.programs.nautilus = {
    enable = lib.mkEnableOption "nautilus";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.nautilus
    ];
    my.xdg.defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    };
    my.hm.wayland.windowManager.niri.settings.binds."Mod+E".spawn = [
      "nautilus"
    ];
  };
}
