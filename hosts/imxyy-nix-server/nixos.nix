{
  lib,
  config,
  username,
  secrets,
  ...
}:
{
  sops.secrets.imxyy-nix-server-hashed-password = {
    sopsFile = secrets.imxyy-nix-server-hashed-password;
    format = "binary";
    neededForUsers = true;
  };
  users.users.${username}.hashedPasswordFile =
    lib.mkForce config.sops.secrets.imxyy-nix-server-hashed-password.path;
  users.users.root.hashedPasswordFile = lib.mkForce config.sops.secrets.imxyy-nix-server-hashed-password.path;
}
