{ pkgs, ... }: {
  home.packages = with pkgs; [
    musescore

    wpsoffice-cn
    nur.repos.rewine.ttf-wps-fonts
    wps-office-fonts

    libreoffice-fresh

    # xmind

    evince

    dooit

    translate-shell

    qq

    element-desktop

    gnome.gnome-clocks
  ];
}
