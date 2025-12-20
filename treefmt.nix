{ inputs, ... }:
{
  imports = [ inputs.treefmt.flakeModule ];
  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    programs = {
      nixfmt.enable = true;
      stylua.enable = true;
      keep-sorted.enable = true;
      typos = {
        enable = true;
        configFile = "typos.toml";
      };
    };
  };
}
