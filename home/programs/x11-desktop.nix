{ pkgs, ... }: {
  home.packages = with pkgs; [
    dwm
    xorg.xinit
    xorg.xauth
    screenkey
  ];
  home.file.".xinitrc".text = ''
    exec dwm
  '';
  xdg.configFile."screenkey.json".source = ./screenkey.json;
}
