{ pkgs, ... }: {
  home.packages = with pkgs; [
    stable.musescore

    /* (wpsoffice-cn.overrideAttrs (oldattrs: {
      src = fetchurl {
        url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/11711/wps-office_11.1.0.11711_amd64.deb";
        hash = "sha256-JHSTZZnOZoTpj8zF4C5PmjTkftEdxbeaqweY3ITiJto=";
        curlOpts = "-e https://www.wps.cn/product/wpslinux";
      };
    })) */
    wpsoffice-cn
    nur.repos.rewine.ttf-wps-fonts
    wps-office-fonts

    libreoffice-fresh

    xmind

    evince

    dooit

    translate-shell

    qq

    element-desktop
  ];
}
