{
  config,
  lib,
  pkgs,
  assets,
  impure,
  ...
}:
let
  niriCfg = config.my.hm.wayland.windowManager.niri;
in
{
  config = lib.mkIf config.my.desktop.wm.niri.enable {
    my.hm = {
      xdg.configFile."niri".source = impure.mkImpureLink ./config;
      xdg.configFile."niri-generated.kdl".text = niriCfg.finalConfig;

      wayland.windowManager.niri.settings = {
        environment.NIXOS_OZONE_WL = "1";

        spawn-at-startup = lib.mkBefore [
          (
            [
              "dbus-update-activation-environment"
              "--systemd"
            ]
            ++ (builtins.attrNames niriCfg.settings.environment)
          )
          [
            "${lib.getExe pkgs.swaybg}"
            "-m"
            "fill"
            "-i"
            (toString assets.wallpaper)
          ]
          [
            "wl-paste"
            "--type"
            "text"
            "--watch"
            "cliphist"
            "store"
          ]
          [
            "wl-paste"
            "--type"
            "image"
            "--watch"
            "cliphist"
            "store"
          ]
          [ "noctalia-shell" ]
        ];

        binds = lib.mkMerge [
          {
            "Mod+G".spawn = [ config.my.desktop.browser.default.command ];
          }
          (builtins.listToAttrs (
            map (n: {
              name = "Mod+${toString n}";
              value.focus-workspace = n;
            }) (lib.range 0 9)
          ))
          (builtins.listToAttrs (
            map (n: {
              name = "Mod+Shift+${toString n}";
              value.move-column-to-workspace = n;
            }) (lib.range 0 9)
          ))
        ];
      };
    };
  };
}
