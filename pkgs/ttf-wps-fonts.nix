{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "ttf-wps-fonts";
  version = "unstable-2024-08-29";

  src = fetchFromGitHub {
    owner = "dv-anomaly";
    repo = "ttf-wps-fonts";
    rev = "8c980c24289cb08e03f72915970ce1bd6767e45a";
    hash = "sha256-x+grMnpEGLkrGVud0XXE8Wh6KT5DoqE6OHR+TS6TagI=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/ttf-wps-fonts
    cp *.ttf *.TTF $out/share/fonts/ttf-wps-fonts

    runHook postInstall
  '';

  meta = {
    description = "Symbol fonts required by wps-office. ";
    homepage = "https://github.com/dv-anomaly/ttf-wps-fonts/tree/8c980c24289cb08e03f72915970ce1bd6767e45a";
  };
}
