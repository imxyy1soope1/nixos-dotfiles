{
  config,
  lib,
  pkgs,
  username,
  userfullname,
  emails,
  hosts,
  ...
}:
let
  cfg = config.my.cli.vcs.git;
in
{
  options.my.cli.vcs.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      programs.git = {
        enable = true;
        settings = {
          gpg.ssh.allowedSignersFile =
            hosts
            |> lib.mapAttrsToList (
              host: key: map (email: "${email} ${key} ${host}") (builtins.attrValues emails)
            )
            |> lib.flatten
            |> lib.concatStringsSep "\n"
            |> pkgs.writeText "allowed-signers"
            |> toString;
          push.autoSetupRemote = true;
          user = {
            name = userfullname;
            email = emails.default;
          };
        };
        signing = {
          format = "ssh";
          signByDefault = true;
          key = "/home/${username}/.ssh/id_ed25519";
        };
      };
      programs.lazygit = {
        enable = true;
      };
    };
  };
}
