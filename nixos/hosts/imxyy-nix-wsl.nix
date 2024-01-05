{ username
, nixos-wsl
, ...
}: {
  imports = [
    nixos-wsl.nixosModules.wsl
  ];
  wsl.enable = true;
  wsl.defaultUser = "${username}";
}
