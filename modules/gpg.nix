{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.my.gpg;
in
{
  options.my.gpg = {
    enable = lib.mkEnableOption "GPG and GPG agent";
  };

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };

    my.hm.programs.gpg.enable = true;

    my.persist.homeDirs = [
      {
        directory = ".gnupg";
        mode = "0700";
      }
    ];
  };
}
