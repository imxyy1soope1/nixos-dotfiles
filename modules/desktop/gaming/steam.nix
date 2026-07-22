{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.gaming.steam;
in
{
  options.my.desktop.gaming.steam = {
    enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        gamescope
      ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    my.persist.homeDirs = [
      ".local/share/Steam"
    ];
  };
}
