{pkgs, ...}: {
  home.packages = with pkgs; [
    go-musicfox
  ];
  xdg.configFile."go-musicfox/go-musicfox.ini".source = ./go-musicfox.ini;
}
