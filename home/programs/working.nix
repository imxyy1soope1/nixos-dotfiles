{ pkgs, ... }: {
  home.packages = with pkgs; [
    musescore

    wpsoffice-cn
    nur.repos.rewine.ttf-wps-fonts
    unstable.libreoffice-fresh

    dooit

    nur.repos.Freed-Wu.translate-shell
    wakatime # translate-shell dep

    qq
  ];
}
