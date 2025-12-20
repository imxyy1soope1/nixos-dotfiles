{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.gaming.minecraft;
in
{
  options.my.desktop.gaming.minecraft = {
    enable = lib.mkEnableOption "minecraft";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = [
      (pkgs.hmcl.overrideAttrs {
        postFixup = ''
          substituteInPlace $out/share/applications/HMCL.desktop --replace-fail 'Exec=hmcl' 'Exec=sh -c "cd ~/.local/share/hmcl; hmcl"'
        '';
      })
    ];

    my.persist.homeDirs = [
      ".minecraft"
      ".local/share/hmcl"
    ];
  };
}
