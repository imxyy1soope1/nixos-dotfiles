{
  lib,
  username,
  ...
}:
{
  imports = [
    ./cli
    ./coding
    ./virt
    ./desktop
    ./i18n
    ./nix.nix
    ./sops.nix
    ./gpg.nix
    ./time.nix
    ./user.nix
    ./xdg.nix
    ./persist.nix
    ./getty-autologin.nix

    (lib.mkAliasOptionModule [ "my" "home" ] [ "home-manager" "users" username ])
  ];
}
