{
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "nix-racer";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./src
    ];
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "Nix substituter proxy with parallel cache queries and latency-aware selection";
    mainProgram = "nix-racer";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
