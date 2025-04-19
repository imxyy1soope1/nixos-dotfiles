{ inputs, ... }:
{
  additions = final: prev: import ../pkgs prev;

  modifications = final: prev: {
    cage = prev.cage.overrideAttrs {
      patches = [ ./cage-specify-output-name.patch ];
    };
    qq = prev.qq.overrideAttrs {
      preInstall = ''
        gappsWrapperArgs+=(
          --prefix GTK_IM_MODULE : fcitx
        )
      '';
    };
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
