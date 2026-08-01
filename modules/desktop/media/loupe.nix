{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.loupe;
  desktop = [ "org.gnome.Loupe.desktop" ];
in
{
  options.my.desktop.media.loupe = {
    enable = lib.mkEnableOption "loupe";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.loupe ];
    my.xdg.defaultApplications = {
      "image/*" = desktop;
      "image/gif" = desktop;
      "image/jpeg" = desktop;
      "image/png" = desktop;
      "image/webp" = desktop;
    };
  };
}
