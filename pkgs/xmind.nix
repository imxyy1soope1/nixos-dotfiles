{ lib, stdenv, fetchurl, makeWrapper, electron, dpkg, ... }:
stdenv.mkDerivation rec {
  pname = "xmind";
  version = "23.11.04336-202311170212";

  src = fetchurl {
    url = "https://dl3.xmind.net/Xmind-for-Linux-amd64bit-${version}.deb";
    sha256 = "3325d935e170f3d56b1d2e01b1f8a9239d8d150dbfb87dab0321eae45abe98c7";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  buildInputs = [
    electron
  ];

  /* desktopItem = makeDesktopItem {
    name = "XMind";
    exec = "XMind";
    icon = "xmind";
    desktopName = "xmind";
    comment = meta.description;
    categories = [ "Office" ];
    mimeTypes = [ "application/xmind" "x-scheme-handler/xmind" ];
  }; */

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    cp -r opt/Xmind/resources/* $out/libexec
    cp -r usr/* $out
    substituteInPlace $out/share/applications/xmind.desktop --replace /opt/Xmind/xmind $out/bin/xmind

    makeWrapper ${electron}/bin/electron $out/bin/xmind \
      --argv0 "xmind" \
      --add-flags "$out/libexec/app.asar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brainstorming and Mind Mapping Software";
    home-page = "https://www.xmind.net";
    license = licenses.unfree;
    mainProgram = "xmind";
    platforms = platforms.linux;
  };
}
