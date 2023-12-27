{ ... }: {
  imports = [
    ./misc.nix
    ./media.nix
    ./term.nix
    ./font.nix
    ./coding.nix
    ./desktop.nix
    ./x11-desktop.nix
    ./wayland-desktop.nix
  ];
}
