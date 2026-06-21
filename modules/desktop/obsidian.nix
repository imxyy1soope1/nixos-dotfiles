{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.obsidian;
in
{
  options.my.desktop.obsidian = {
    enable = lib.mkEnableOption "obsidian";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      obsidian
    ];
    my.persist.homeDirs = [
      ".config/obsidian"
    ];
  };
}
