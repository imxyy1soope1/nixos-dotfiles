{ ... }:
{
  imports = [
    ./nixos.nix
    ./hardware.nix
    ./home.nix
    ./virt.nix
    ./net.nix
  ];
}
