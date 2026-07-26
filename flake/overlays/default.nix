{
  inputs,
  lib,
  config,
  ...
}:
let
  channel = channel: final: _prev: {
    ${channel} = import inputs."nixpkgs-${channel}" {
      inherit (final.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  };
in
[
  (
    final: prev:
    lib.infuse prev {
      cage.__output.patches.__append = [ ./cage-specify-output-name.patch ];
      bottles.__input.removeWarningPopup.__assign = true;

      easytier.__assign = final.stable.easytier;

      vaultwarden.__assign = final.unstable-small.vaultwarden;
    }
  )
  (channel "stable")
  (channel "unstable-small")
  (channel "master")
]
