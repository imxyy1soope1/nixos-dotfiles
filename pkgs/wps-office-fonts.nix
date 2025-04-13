{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wps-office-fonts";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/Universebenzene/wps-office-fonts/archive/refs/tags/v${version}.tar.gz";
    sha256 = "db01fc07324115b181cb06f50dfe09fd17feee132c46423ee70b260830211224";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/wps-office-fonts
    cp *.TTF $out/share/fonts/wps-office-fonts

    runHook postInstall
  '';

  meta = {
    description = "The wps-office-fonts package contains Founder Chinese fonts";
    homepage = "https://github.com/Universebenzene/wps-office-fonts";
    license = lib.licenses.unlicense;
  };
}
