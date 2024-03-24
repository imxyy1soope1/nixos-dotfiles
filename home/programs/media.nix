{ pkgs, ... }: {
  home.packages = with pkgs; [
    mpd
    mpc-cli
    playerctl
    go-musicfox

    spotify

    ffmpeg

    cava
  ];
  xdg.configFile."go-musicfox/go-musicfox.ini".source = ./go-musicfox.ini;
  xdg.configFile."mpd/mpd.conf".source = ./mpd/mpd.conf;
  xdg.configFile."cava" = {
    source = ./cava;
    recursive = true;
  };
}
