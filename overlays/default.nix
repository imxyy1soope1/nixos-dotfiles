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

      sing-box.__output.version.__assign = "unstable-2024-08-16";
      sing-box.__output.src.__assign = final.fetchFromGitHub {
        owner = "PuerNya";
        repo = "sing-box";
        rev = "067c81a73e1fb7b6edbc58e6b06b8b943fa6c40a";
        hash = "sha256-03mkClYVAfAatfYJ1OuM1OvABj/fgbseqK8jPbBtI8g=";
      };
      sing-box.__output.vendorHash.__assign = "sha256-ZWFZkVRtybQAK9oZRIMBGeDfxXTV7kzXwNSbkvslMFk=";
      sing-box.__output.postInstall.__assign = "";
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
