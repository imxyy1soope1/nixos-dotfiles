{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.qq;
in
{
  options.my.programs.qq = {
    enable = lib.mkEnableOption "qq";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.qq-wayland
    ];
    my.persist.homeDirs = [
      ".config/QQ"
    ];
  };
}
