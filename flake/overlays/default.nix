{
  inputs,
  lib,
  config,
  ...
}:
[
  (final: _prev: {
    mv = inputs.multiverse.lib.mkMultiverse {
      inherit (final.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  })
  (
    final: prev:
    lib.infuse prev {
      cage.__output.patches.__append = [ ./cage-specify-output-name.patch ];
      bottles.__input.removeWarningPopup.__assign = true;
    }
  )
]
