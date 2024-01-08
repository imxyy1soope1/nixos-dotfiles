{ ... }: {
  imports = [
    ./misc.nix
    ./desktop.nix
    ./x11-desktop.nix
    ./wayland-desktop.nix
    ./xdg.nix
    ./media.nix
    ./wine.nix
    ./coding.nix
    ./working.nix
    ./gaming.nix
    ./persistence.nix
  ];
}
