{ fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-starship";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dmmulroy";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-wmQn1qw+jfxH9xBS7bdgWiK369bCeGV9klZzlFHrGOw=";
  };

  cargoHash = "sha256-dGutKgOG0gPDYcTODrBUmmJBl2k437E5/lz+9cFzgs4=";

  meta = {
    mainProgram = "jj-starship";
  };
})
