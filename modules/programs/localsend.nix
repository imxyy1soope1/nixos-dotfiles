{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.localsend;
in
{
  options.my.programs.localsend = {
    enable = lib.mkEnableOption "localsend";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.localsend
    ];
    my.persist.homeDirs = [
      ".local/share/org.localsend.localsend_app"
    ];
  };
}
