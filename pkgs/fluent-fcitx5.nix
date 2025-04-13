{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "fluent-fcitx5";
  version = "unstable-2024-03-10";

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "Fluent-fcitx5";
    rev = "e4745fd598ddfd4b26f693cfb951cd028575a1f0";
    hash = "sha256-tVPp6kFgsWlSLcEUffOvXCWDEV0y7qcSqYKQkGO7lrM=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r Fluent* $out/share/fcitx5/themes

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Fluent-Design theme with blur effect and shadow. ";
    homepage = "https://github.com/Reverier-Xu/Fluent-fcitx5";
    platforms = platforms.all;
  };
}
