# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  win11-icon-theme = pkgs.callPackage ./win11-icon-theme.nix { inherit (pkgs) lib stdenvNoCC fetchFromGitHub gtk3 jdupes breeze-icons; };
  mono-gtk-theme = pkgs.callPackage ./mono-gtk-theme.nix { inherit (pkgs) lib stdenvNoCC fetchFromGitHub; };
}
