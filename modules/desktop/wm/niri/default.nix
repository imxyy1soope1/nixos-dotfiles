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
    # Copied from home-manager, MIT licensed
    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "KDL value";
            };
        in
        attrsOf valueType;
      default = { };
      description = ''
        Configuration added to {file}`$XDG_CONFIG_HOME/niri/config.kdl`.
        See <https://yalter.github.io/niri/Configuration%3A-Introduction.html> for the full list of options.
      '';
    };
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

    services.system76-scheduler.enable = true;

    my.hm = {
      home.packages = with pkgs; [
        xwayland-satellite

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
