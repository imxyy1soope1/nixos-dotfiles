{pkgs, ...}: {
  home.packages = with pkgs; [
    dwm
    screenkey
  ];
  xdg.configFile."screenkey.json".source = ./screenkey.json;
}
