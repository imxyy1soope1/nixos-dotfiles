{ username, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];
  wsl.enable = true;
  wsl.defaultUser = username;

  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # fix vscode remote
  programs.nix-ld.enable = true;
}
