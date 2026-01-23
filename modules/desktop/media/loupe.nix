{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.loupe;
in
{
  options.my.desktop.media.loupe = {
    enable = lib.mkEnableOption "loupe";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [ pkgs.loupe ];
  };
}
