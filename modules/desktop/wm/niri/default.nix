{
  lib,
  config,
  pkgs,
  impure,
  secrets,
  username,
  ...
}:
let
  cfg = config.my.desktop.wm.niri;
  cursorCfg = config.my.hm.home.pointerCursor;
in
{
  options.my.desktop.wm.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    programs.noctalia-greeter = {
      enable = true;
      passwordless-sync-users = [ username ];
      settings = {
        cursor = {
          theme = cursorCfg.name;
          size = cursorCfg.size;
          path = "${cursorCfg.package}/share/icons";
        };
        appearance = {
          hide_logo = true;
          scheme_selector_position = "hidden";
        };
      };
    };

    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;

    sops.secrets.noctalia-storage-key = {
      sopsFile = secrets.noctalia-storage-key;
      format = "binary";
      owner = username;
      group = "users";
      mode = "0400";
    };

    my.persist.homeDirs = [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];

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
