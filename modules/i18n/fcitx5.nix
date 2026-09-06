{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.i18n.fcitx5;
  mkFcitx =
    final: prev:
    { pkg, desktops }:
    {
      ${pkg} = final.symlinkJoin {
        name = prev.${pkg}.name;
        paths = [ prev.${pkg} ];
        postBuild = lib.concatLines (
          map (desktop: ''
            rm $out/share/applications/${desktop}.desktop
            substitute ${prev.${pkg}}/share/applications/${desktop}.desktop $out/share/applications/${desktop}.desktop \
              --replace-fail 'Exec=' 'Exec=env QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx '
          '') desktops
        );
      };
    };
in
{
  options.my.i18n.fcitx5 = {
    enable = lib.mkEnableOption "default fcitx5 settings";
  };

  config = lib.mkIf cfg.enable {
    my.persist.homeDirs = [
      # User dicts & prefs
      ".local/share/fcitx5"
    ];
    my.hm.i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          # fcitx5-mozc
          fcitx5-lightly
        ];
        waylandFrontend = true;
        settings = {
          globalOptions = {
            "PreeditEnabledByDefault"."0" = true;
            "Hotkey"."EnumerateWithTriggerKeys" = false;
            "Hotkey/TriggerKeys"."0" = "";
            "Hotkey/AltTriggerKeys"."0" = "Shift_L";
            "Hotkey/EnumerateForwardKeys"."0" = "";
            "Hotkey/EnumerateBackwardKeys"."0" = "";
          };
          inputMethod = {
            "Groups/0" = {
              "Name" = "Default";
              "Default Layout" = "us";
              "DefaultIM" = "pinyin";
            };
            "Groups/0/Items/0" = {
              "Name" = "keyboard-us";
              "Layout" = "";
            };
            "Groups/0/Items/1" = {
              "Name" = "pinyin";
              "Layout" = "";
            };
            "GroupOrder"."0" = "Default";
          };
          addons = {
            classicui.globalSection = {
              WheelForPaging = true;
              Font = "sans-serif 10";
              MenuFont = "Noto Sans CJK SC 10";
              TrayFont = "Noto Sans CJK SC Bold 10";
              Theme = "lightly";
              PerScreenDPI = true;
              EnableFractionalScale = true;
            };
            punctuation.globalSection = {
              HalfWidthPuncAfterLetterOrNumber = true;
              TypePairedPunctuationsTogether = false;
              Enabled = true;
            };
            pinyin = {
              globalSection = {
                PageSize = 9;
                EmojiEnabled = false;
                ChaiziEnabled = true;
                ExtBEnabled = true;
                CloudPinyinEnabled = true;
                CloudPinyinIndex = 2;
                PreeditInApplication = true;
              };
              sections = {
                Fuzzy = {
                  VE_UE = true;
                  NG_GN = true;
                  Inner = true;
                  InnerShort = true;
                  PartialFinal = false;
                  V_U = true;
                  IN_ING = true;
                  U_OU = true;
                };
              };
            };
            cloudpinyin.globalSection = {
              Backend = "Baidu";
              MinimumPinyinLength = 4;
            };
            clipboard.globalSection = {
              TriggerKey = "";
            };
          };
        };
      };
    };
    nixpkgs.overlays = [
      (
        final: prev:
        lib.mergeAttrsList (
          map (mkFcitx final prev) [
            {
              pkg = "wechat";
              desktops = [ "wechat" ];
            }
            {
              pkg = "wpsoffice-cn";
              desktops = map (app: "wps-office-${app}") [
                "et"
                "pdf"
                "prometheus"
                "wpp"
                "wps"
              ];
            }
          ]
        )
      )
    ];
    my.desktop.wm.niri.settings = {
      binds."Mod+Space".spawn = [
        "fcitx5-remote"
        "-t"
      ];
    };
  };
}
