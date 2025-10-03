{
  config,
  lib,
  pkgs,
  username,
  userdesc,
  secrets,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default user settings";
  optionPath = [ "user" ];
  config' = {
    programs.zsh.enable = true;

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
        shell = pkgs.zsh;
        extraGroups = [
          username
          "wheel"
        ];
        hashedPasswordFile = lib.mkDefault config.sops.secrets.imxyy-nix-hashed-password.path;
      };
      groups.${username} = { };
    };
    users.users.root.hashedPasswordFile = lib.mkDefault config.sops.secrets.imxyy-nix-hashed-password.path;

    security.sudo.enable = false;
    security.doas = {
      enable = true;
      extraRules = [
        {
          users = [ username ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };
    environment.shellAliases = {
      sudoedit = "doasedit";
    };
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "sudo" ''exec doas "$@"'')
      (pkgs.writeShellScriptBin "doasedit" ''
        if [ -n "''${2}" ]; then
          printf 'Expected only one argument\n'
          exit 1
        elif [ -z "''${1}" ]; then
          printf 'No file path provided\n'
          exit 1
        elif [ "$(id -u)" -eq 0 ]; then
          printf 'Cannot be run as root\n'
          exit 1
        fi

        set -eu

        tempdir="$(mktemp -d)"

        trap 'rm -rf $tempdir' EXIT
        srcfile="$(doas realpath "$1")"

        if doas [ -f "$srcfile" ]; then
          doas cp -a "$srcfile" "$tempdir"/file
          doas cp -a "$tempdir"/file "$tempdir"/edit

          # make sure that the file is editable by user
          doas chown "$USER":"$USER" "$tempdir"/edit
          chmod 600 "$tempdir"/edit
        else
          # create file with "regular" system permissions (root:root 644)
          touch "$tempdir"/file
          doas chown root:root "$tempdir"/file
        fi

        $EDITOR "$tempdir"/edit

        doas tee "$tempdir"/file 1>/dev/null < "$tempdir"/edit

        if doas cmp -s "$tempdir/file" "$srcfile"; then
          printf 'Skipping write; no changes.\n'
          exit 0
        else
          doas mv -f "$tempdir"/file "$srcfile"
          exit 0
        fi
      '')
    ];

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
