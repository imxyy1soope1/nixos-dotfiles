{ inputs, ... }: {
  imports = [
    inputs.treefmt.flakeModule
  ];
  perSystem.treefmt = { lib, pkgs, ... }: {
    projectRootFile = "flake.nix";
    programs = {
      nixfmt.enable = true;
      keep-sorted.enable = true;
      stylua.enable = true;
    };
    settings.formatter.tombi = {
      command = "${pkgs.bash}/bin/bash";
      options = [
        "-euc"
        ''
          for file in "$@"; do
            ${lib.getExe pkgs.tombi} fmt $file
          done
        ''
        "--"
      ];
      includes = [ "*.toml" ];
    };
    settings.excludes = [ "secrets/*" ];
  };
}
