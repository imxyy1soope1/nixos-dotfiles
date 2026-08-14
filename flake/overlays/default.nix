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

      jetbrains-mono.__assign = lib.warn ''
        nanoemoji https://github.com/NixOS/nixpkgs/pull/552075
      '' (final.mv.at "2026-08-12").jetbrains-mono;
      moonlight-qt.__assign = lib.warn ''
        moonlight-qt https://github.com/NixOS/nixpkgs/pull/552544
      '' (final.mv.at "2026-08-10").moonlight-qt;
    }
  )
]
