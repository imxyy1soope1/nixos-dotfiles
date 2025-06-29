{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "mpd";
  optionPath = [
    "cli"
    "media"
    "mpd"
  ];
  config' = {
    my.home = {
      home.packages = with pkgs.stable; [
        mpd
        mpc-cli
      ];
      services.mpris-proxy.enable = true;
      xdg.configFile."mpd/mpd.conf".source = ./mpd.conf;
    };
    my.persist.homeFiles = [
      ".config/mpd/mpd.db"
    ];
  };
}
