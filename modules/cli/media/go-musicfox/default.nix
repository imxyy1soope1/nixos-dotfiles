{
  config,
  lib,
  pkgs,
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
      home = {
        home.packages = with pkgs; [
          playerctl
          go-musicfox
        ];
        xdg.configFile."go-musicfox/go-musicfox.ini".source = ./go-musicfox.ini;
      };

      cli.media.mpd.enable = true;
    };
  };
}
