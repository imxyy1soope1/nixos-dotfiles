{
  inputs,
  lib,
  config,
  ...
}:
let
  mkWayland =
    final: prev:
    {
      pkg,
      exe,
      desktop,
    }:
    {
      "${pkg}-wayland" = final.symlinkJoin {
        pname = prev.${pkg}.pname;
        version = prev.${pkg}.version;
        paths = [ prev.${pkg} ];
        nativeBuildInputs = [ final.makeWrapper ];
        postBuild = ''
          rm $out/share/applications/${desktop}.desktop
          substitute ${prev.${pkg}}/share/applications/${desktop}.desktop $out/share/applications/${desktop}.desktop \
            --replace-quiet "${prev.${pkg}}" $out
          wrapProgram $out/bin/${exe} --add-flags "--wayland-text-input-version=3"
        '';
      };
    };
in
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
  (
    final: prev:
    lib.mergeAttrsList (
      map (mkWayland final prev) [
        {
          pkg = "qq";
          exe = "qq";
          desktop = "qq";
        }
        {
          pkg = "vscodium";
          exe = "codium";
          desktop = "codium";
        }
        {
          pkg = "signal-desktop";
          exe = "signal-desktop";
          desktop = "signal";
        }
      ]
    )
  )
]
