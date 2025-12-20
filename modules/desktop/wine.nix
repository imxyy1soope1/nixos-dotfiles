{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.wine;
in
{
  options.my.desktop.wine = {
    enable = lib.mkEnableOption "wine";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      wine-wayland
      bottles
    ];
    my.persist.homeDirs = [
      ".local/share/bottles"
    ];
  };
}
