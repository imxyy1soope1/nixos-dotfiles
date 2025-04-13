{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "win11-icon-themes";
  version = "main";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Win11-icon-theme";
    rev = "9c69f73b00fdaadab946d0466430a94c3e53ff68";
    sha256 = "sha256-jN55je9BPHNZi5+t3IoJoslAzphngYFbbYIbG/d7NeU=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    patchShebangs ./install.sh
    sed -i "s@shift 2@shift 1@" ./install.sh
    ./install.sh -d "$out/share/icons" -n Win11
    ./install.sh -d "$out/share/icons" -n Win11 -a

    runHook postInstall
  '';

  meta = {
    description = "A colorful design icon theme for linux desktops";
    homepage = "https://github.com/yeyushengfan258/Win11-icon-theme";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
}
