{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "gpg";
  optionPath = [ "gpg" ];
  extraConfig = {
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
    my.persist.homeDirs = [ ".gnupg" ];
  };
}
