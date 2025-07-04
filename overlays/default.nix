{ inputs, infuse, ... }:
{
  additions = final: prev: import ../pkgs prev;

  modifications =
    final: prev:
    infuse prev {
      cage.__output.patches.__append = [ ./cage-specify-output-name.patch ];
      matrix-synapse.__assign = final.stable.matrix-synapse;
      bottles.__input.removeWarningPopup.__assign = true;
      qq.__output.preInstall.__append = ''
        gappsWrapperArgs+=(
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--wayland-text-input-version=3}}"
        )
      '';

      sing-box.__assign = prev.sing-box.overrideAttrs (finalAttrs: {
        version = "1.11.14";
        src = final.fetchFromGitHub {
          owner = "qjebbs";
          repo = "sing-box";
          # due to faulty tag generation
          tag = "v${finalAttrs.version}+rev";
          hash = "sha256-/p2PBTeeRJW3iq/BXJlw/Qn92Nrnw9fmUn5yNGl/o34=";
        };
        vendorHash = "sha256-C2HCNOzP1Jg3vz2i9uPmM1wC7Sw2YNt7MdYn939cu1Y=";
        postInstall = "";
      });
    };

  # this allows us to access specific version of nixpkgs
  # by `pkgs.unstable`, `pkgs.stable` and `pkgs.master`
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nur-packages = inputs.nur.overlays.default;
}
