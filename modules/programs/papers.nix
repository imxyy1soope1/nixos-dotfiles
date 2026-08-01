{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.papers;
in
{
  options.my.programs.papers = {
    enable = lib.mkEnableOption "papers";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.papers
    ];
    my.xdg.defaultApplications."application/pdf" = [ "org.gnome.Papers.desktop" ];
  };
}
