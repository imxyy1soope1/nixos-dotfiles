{ pkgs, ... }: {
  home.packages = with pkgs; [
    mpd
    mpc-cli
    playerctl
    go-musicfox

    vlc

    shotwell

    thunderbird
  ];
  xdg.configFile."go-musicfox/go-musicfox.ini".source = ./go-musicfox.ini;
  xdg.configFile."mpd/mpd.conf".source = ./mpd/mpd.conf;
}
