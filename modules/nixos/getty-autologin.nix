{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.getty;

  baseArgs = [
    "--login-program"
    "${cfg.loginProgram}"
  ] ++ optionals (cfg.loginOptions != null) [
    "--login-options"
    cfg.loginOptions
  ] ++ cfg.extraArgs;

  gettyCmd = args:
    "@${pkgs.util-linux}/sbin/agetty agetty ${escapeShellArgs baseArgs} ${args}";

  forAllAutologinTTYs = gen:
    attrsets.mergeAttrsList (
      builtins.map
        (
          ttynum: { "getty@tty${ttynum}" = gen ttynum; }
        )
        cfg.autologin.ttys
    );

  autologinModule = types.submodule ({ ... }: {
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
        type = types.listOf types.str;
        default = [ "6" ];
        description = mdDoc ''
          TTY numbers for autologin.user to login to.
        '';
      };
    };
  });

in

{
  # imports = [
  #   (mkRemovedOptionModule ["services" "getty" "autologinUser"] "services.getty.autologinUser removed, use services.getty.autologin instead")
  # ];


  ###### interface

  options = {

    services.getty = {

      autologin = mkOption {
        type = autologinModule;
        default = { };
        description = ''
          Submodule to configure autologin.
        '';
      };
    };

  };

  ###### implementation

  config = (mkIf cfg.autologin.enable {
    systemd.services = forAllAutologinTTYs (ttynum: {
      overrideStrategy = "asDropin"; # needed for templates to work
      serviceConfig.ExecStart = [
        ""
        (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 -a ${cfg.autologin.user} $TERM")
      ];
    });
  });

}
