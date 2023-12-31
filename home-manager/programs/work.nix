{ pkgs, ... }: {
  home.packages = with pkgs; [
    musescore
    wpsoffice-cn
    libreoffice-fresh
  ];
}
