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
    "cmd"
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

      cmd.media.mpd.enable = true;
    };
  };
}
