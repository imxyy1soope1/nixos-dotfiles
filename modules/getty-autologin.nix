{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.autologin;
  gettycfg = config.services.getty;

  baseArgs =
    [
      "--login-program"
      "${gettycfg.loginProgram}"
    ]
    ++ optionals (gettycfg.loginOptions != null) [
      "--login-options"
      gettycfg.loginOptions
    ]
    ++ gettycfg.extraArgs;

  gettyCmd = args: "@${pkgs.util-linux}/sbin/agetty agetty ${escapeShellArgs baseArgs} ${args}";

  forAllAutologinTTYs =
    config:
    attrsets.mergeAttrsList (
      builtins.map (ttynum: { "getty@tty${toString ttynum}" = config; }) cfg.ttys
    );

  autologinModule = types.submodule (
    { ... }:
    {
      options = {
        enable = mkEnableOption "autologin";
        user = mkOption {
          type = types.str;
          default = "";
          example = "foo";
          description = mdDoc ''
            Username of the account that will be automatically logged in at the console.
          '';
        };
        ttys = mkOption {
          type = types.listOf types.int;
          default = [ 6 ];
          description = mdDoc ''
            TTY numbers for autologin.user to login to.
          '';
        };
      };
    }
  );

in

{
  ###### interface

  options = {

    my.autologin = mkOption {
      type = autologinModule;
      default = { };
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services = forAllAutologinTTYs {
      overrideStrategy = "asDropin"; # needed for templates to work
      serviceConfig.ExecStart = [
        ""
        (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 -a ${cfg.user} $TERM")
      ];
    };
  };

}
