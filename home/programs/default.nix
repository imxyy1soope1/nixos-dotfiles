{ ... }: {
  imports = [
    ./xdg.nix
    ./misc.nix
    ./media.nix
    ./work.nix
    ./game.nix
    ./wine.nix
    ./coding.nix
    ./desktop.nix
    ./x11-desktop.nix
    ./wayland-desktop.nix
  ];
}
