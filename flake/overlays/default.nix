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

      niri-unstable.__input.libdisplay-info.__assign = final.unstable-small.libdisplay-info_0_3;
    }
  )
  (channel "stable")
  (channel "unstable-small")
  (channel "master")
]
