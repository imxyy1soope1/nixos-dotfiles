{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.wpsoffice;
in
{
  options.my.programs.wpsoffice = {
    enable = lib.mkEnableOption "wpsoffice";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      wpsoffice-cn
      wps-office-fonts
      ttf-wps-fonts
    ];
    my.persist.homeDirs = [
      ".config/Kingsoft"
      ".local/share/Kingsoft"
    ];
  };
}
