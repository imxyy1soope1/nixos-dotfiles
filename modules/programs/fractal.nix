{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.fractal;
in
{
  options.my.programs.fractal = {
    enable = lib.mkEnableOption "fractal";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.fractal
    ];
    my.persist.homeDirs = [
      ".local/share/fractal"
    ];
  };
}
