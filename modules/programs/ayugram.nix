{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.ayugram;
in
{
  options.my.programs.ayugram = {
    enable = lib.mkEnableOption "ayugram";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.ayugram-desktop
    ];
    my.persist.homeDirs = [
      ".local/share/AyuGramDesktop"
    ];
  };
}
