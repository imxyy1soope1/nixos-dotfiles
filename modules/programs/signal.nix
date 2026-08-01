{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.signal;
in
{
  options.my.programs.signal = {
    enable = lib.mkEnableOption "signal";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.signal-desktop-wayland
    ];
    my.persist.homeDirs = [
      ".config/Signal"
    ];
  };
}
