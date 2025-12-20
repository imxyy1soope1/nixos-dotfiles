{
  config,
  lib,
  pkgs,
  username,
  userfullname,
  useremail,
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
            (pkgs.writeText "allowed_signers" ''
              imxyy1soope1@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
              imxyy@imxyy.top ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
            '').outPath;
          push.autoSetupRemote = true;
          user = {
            name = userfullname;
            email = useremail;
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
