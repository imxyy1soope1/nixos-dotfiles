{
  config,
  lib,
  ...
}:
let
  cfg = config.my.desktop.wm.all;
in
{
  options.my.desktop.wm.all = {
    enable = lib.mkEnableOption "all window managers";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.wm = {
      cage.enable = true;
      niri.enable = true;
    };
  };
}
