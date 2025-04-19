{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "translate-shell";
  version = "0.9.7.1";

  src = fetchFromGitHub {
    owner = "soimort";
    repo = pname;
    rev = "gh-pages";
    hash = "sha256-YQevXwslWzHen9n+Fn0a+oNx/EKg0Kd/Ge8ksYP0ekY=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    patchShebangs ./trans
    cp ./trans $out/bin/trans

    runHook postInstall
  '';

  meta = {
    description = "Command-line translator using Google Translate, Bing Translator, Yandex.Translate, etc.";
    homepage = "https://github.com/soimort/translate-shell";
    license = lib.licenses.unlicense;
  };
}
