{
  config,
  lib,
  pkgs,
  hostname,
  username,
  userdesc,
  secrets,
  ...
}:
let
  cfg = config.my.user;
in
{
  options.my.user = {
    enable = lib.mkEnableOption "default user settings" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.imxyy-nix-hashed-password = {
      sopsFile = secrets.imxyy-nix-hashed-password;
      format = "binary";
      neededForUsers = true;
    };
    users = {
      mutableUsers = false;
      users.${username} = {
        isNormalUser = true;
        description = userdesc;
        extraGroups = [
          username
          "wheel"
          "input"
        ];
        hashedPasswordFile = lib.mkDefault config.sops.secrets.imxyy-nix-hashed-password.path;
      };
      groups.${username} = { };
    };
    users.users.root.hashedPasswordFile = lib.mkDefault config.sops.secrets.imxyy-nix-hashed-password.path;

    security.sudo = {
      enable = true;
      extraRules = [
        {
          users = [ "imxyy" ];
          commands = lib.singleton {
            command = "ALL";
            options = lib.optionals (hostname == "imxyy-nix") [ "NOPASSWD" ];
          };
        }
      ];
    };

    nix.settings.trusted-users = [
      "root"
      username
    ];

    my.hm.home = {
      inherit username;
      homeDirectory = "/home/${username}";
    };
  };
}
