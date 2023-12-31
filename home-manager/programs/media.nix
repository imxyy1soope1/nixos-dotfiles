{ pkgs, ... }: {
  home.packages = with pkgs; [
    mpd
    mpc-cli
    go-musicfox
  ];
  xdg.configFile."go-musicfox/go-musicfox.ini".source = ./go-musicfox.ini;
  xdg.configFile."mpd/mpd.conf".source = ./mpd/mpd.conf;
}
