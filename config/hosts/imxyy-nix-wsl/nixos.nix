{ username, nixos-wsl, ... }:
{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];
  wsl.enable = true;
  wsl.defaultUser = "${username}";

  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
