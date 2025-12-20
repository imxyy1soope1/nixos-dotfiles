{ username, lib, ... }:
{
  # WSL-specific configuration
  wsl = {
    enable = true;
    defaultUser = username;
  };

  # Fix VSCode remote
  programs.nix-ld.enable = true;

  # Force platform (WSL is always x86_64-linux)
  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";

  # Disable desktop features
  my = {
    audio.enable = false;
    bluetooth.enable = false;
    fonts.enable = false;
  };

  # Disable persistence for WSL
  my.persist.enable = false;
}
