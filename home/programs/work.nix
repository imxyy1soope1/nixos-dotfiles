{ pkgs, ... }: {
  home.packages = with pkgs; [
    musescore
    wpsoffice-cn
    libreoffice-fresh

    dooit

    nur.repos.Freed-Wu.translate-shell
    wakatime # translate-shell dep

    qq
  ];
}
