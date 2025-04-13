{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "mono-gtk-theme";
  version = "main";

  src = fetchFromGitHub {
    owner = "witalihirsch";
    repo = "Mono-gtk-theme";
    rev = "89fa83a14b4e26c5b8fc4dbfa5558a7df704d5a4";
    sha256 = "sha256-NaZgOOo5VVTlEand3qWryZ5ceNmyHaEt0aeT7j/KwvE=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{Mono-gtk-theme,themes}
    cp -r MonoTheme $out/share/themes
    cp -r MonoThemeDark $out/share/themes
    cp LICENSE $out/share/Mono-gtk-theme

    runHook postInstall
  '';

  meta = {
    description = "...";
    homepage = "https://github.com/witalihirsch/Mono-gtk-theme";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
}
