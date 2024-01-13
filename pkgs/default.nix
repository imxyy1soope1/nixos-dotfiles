# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
let
  packages = [
    "win11-icon-theme"
    "mono-gtk-theme"
    "fcitx5-themes"
    "fcitx5-lightly"
  ];
in
pkgs.lib.genAttrs packages (package: pkgs.callPackage ./${package}.nix pkgs)
