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
      package = pkgs.steam;
      extraPackages = with pkgs; [
        gamescope
      ];
    };
    my.persist.homeDirs = [
      ".local/share/Steam"
    ];
  };
}
