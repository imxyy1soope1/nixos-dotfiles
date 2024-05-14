pkgs:
let
  packages = [
    "win11-icon-theme"
    "mono-gtk-theme"
    "fcitx5-themes"
    "fcitx5-lightly"
    "fluent-fcitx5"
    "xmind"
    "wps-office-fonts"
    "translate-shell"
  ];
in
pkgs.lib.genAttrs packages (package: pkgs.callPackage ./${package}.nix pkgs)
