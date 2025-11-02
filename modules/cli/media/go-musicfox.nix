{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "go-musicfox";
  optionPath = [
    "cli"
    "media"
    "go-musicfox"
  ];
  config' = {
    my = {
      hm = {
        home.packages = with pkgs; [
          playerctl
          go-musicfox
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
