{
  lib,
  config,
  pkgs,
  impure,
  ...
}:
let
  cfg = config.my.desktop.wm.niri;
  pkg = pkgs.niri-unstable;
in
{
  options.my.desktop.wm.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkg;
      # We manage xdg.portal ourselves below.
      withXDG = false;
    };
    services.displayManager = {
      ly = {
        enable = true;
        settings = {
          animation = "matrix";
          session_log = ".local/state/ly-session.log";
          shell = false;
        };
      };
    };

    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    my.persist.homeDirs = [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];

    xdg.portal = {
      enable = true;
      config = {
        niri = {
          default = [
            "gnome"
          ];
          "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
    };
    # Keep switch-to-configuration from stopping the running compositor
    # when the niri store path changes; niri-nix dropped this drop-in in
    # acccaf2202. The new binary takes effect on next login instead.
    systemd.user.units."niri.service" = {
      overrideStrategy = "asDropinIfExists";
      text = ''
        [Service]
        X-StopIfChanged=false
        X-RestartIfChanged=false
      '';
    };

    services.system76-scheduler.enable = true;

    my.hm = {
      home.packages = with pkgs; [
        xwayland-satellite-unstable

        wl-clipboard
        cliphist
        brightnessctl

        mission-center

        xdg-terminal-exec
      ];

      services.system76-scheduler-niri.enable = true;

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };
      xdg.configFile."noctalia".source = impure.mkImpureLink ./noctalia;
    };
  };
}
