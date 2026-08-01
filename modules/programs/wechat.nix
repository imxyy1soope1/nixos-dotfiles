{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.wechat;
in
{
  options.my.programs.wechat = {
    enable = lib.mkEnableOption "wechat";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      pkgs.wechat
    ];
    my.persist.homeDirs = [
      ".xwechat"
    ];
  };
}
