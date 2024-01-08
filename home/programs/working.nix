{ pkgs, ... }: {
  home.packages = with pkgs; [
    musescore
    wpsoffice-cn
    unstable.libreoffice-fresh

    dooit

    nur.repos.Freed-Wu.translate-shell
    wakatime # translate-shell dep

    qq
  ];
}
