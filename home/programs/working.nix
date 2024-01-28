{ pkgs, ... }: {
  home.packages = with pkgs; [
    musescore

    (wpsoffice-cn.overrideAttrs (oldattrs: {
      src = fetchurl {
        url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/11711/wps-office_11.1.0.11711_amd64.deb";
        hash = "sha256-JHSTZZnOZoTpj8zF4C5PmjTkftEdxbeaqweY3ITiJto=";
        curlOpts = "-e https://www.wps.cn/product/wpslinux";
      };
    }))
    # wpsoffice
    nur.repos.rewine.ttf-wps-fonts
    wps-office-fonts
    unstable.libreoffice-fresh

    xmind

    evince

    stable.dooit

    # nur.repos.Freed-Wu.translate-shell
    # wakatime # translate-shell dep

    translate-shell

    qq

    element-desktop
  ];
}