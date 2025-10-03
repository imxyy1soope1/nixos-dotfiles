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
          sopsFile = secrets."go-musicfox.ini";
          format = "binary";
          path = "${config.my.hm.xdg.configHome}/go-musicfox/go-musicfox.ini";
        };
      };

      cli.media.mpd.enable = true;

      persist.homeDirs = [
        ".config/go-musicfox/db"
      ];
      persist.homeFiles = [
        ".config/go-musicfox/cookie"
      ];
    };
  };
}
