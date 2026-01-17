{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  cfg = config.my.cli.media.go-musicfox;
in
{
  options.my.cli.media.go-musicfox = {
    enable = lib.mkEnableOption "go-musicfox";
  };

  config = lib.mkIf cfg.enable {
    my = {
      hm = {
        home.packages = [
          pkgs.go-musicfox
        ];
        sops.secrets.go-musicfox = {
          sopsFile = secrets.go-musicfox;
          format = "binary";
          path = "${config.my.hm.xdg.configHome}/go-musicfox/config.toml";
        };
      };

      desktop.media.mpv.enable = lib.mkForce true;

      persist.homeDirs = [
        ".local/share/go-musicfox/db"
      ];
      persist.homeFiles = [
        ".local/share/go-musicfox/cookie"
      ];
    };
  };
}
