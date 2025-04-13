{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "fcitx5-themes";
  version = "unstable-2022-09-28";

  src = fetchFromGitHub {
    owner = "thep0y";
    repo = "fcitx5-themes";
    rev = "9d6e437289aa8de61d2c198b2e6ce4b5edea204f";
    hash = "sha256-iNOquWc6d1rgdWeGPBQ6na/bq+ZOV9cx4MCLf3SdBLg=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    rm -rf images README.md install.sh

    mkdir -p $out/share/fcitx5/themes
    cp -r * $out/share/fcitx5/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "fcitx5的简约风格皮肤——四季";
    homepage = "https://github.com/thep0y/fcitx5";
    platforms = platforms.all;
  };
}
