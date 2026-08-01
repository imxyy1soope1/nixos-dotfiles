{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.element;
in
{
  options.my.programs.element = {
    enable = lib.mkEnableOption "element";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.element-desktop
    ];
    my.persist.homeDirs = [
      ".config/Element"
    ];
  };
}
