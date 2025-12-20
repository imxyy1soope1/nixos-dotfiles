{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.i18n.fcitx5;
in
{
  options.my.i18n.fcitx5 = {
    enable = lib.mkEnableOption "default fcitx5 settings";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
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
          addons =
            let
              true = "True";
              false = "False";
            in
            {
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
        ignoreUserConfig = true;
      };
    };
    nixpkgs.overlays = [
      (
        final: prev:
        lib.mergeAttrsList (
          map
            (
              {
                pkg,
                exe,
                desktop,
              }:
              {
                ${pkg} = final.symlinkJoin {
                  pname = prev.${pkg}.pname;
                  version = prev.${pkg}.version;
                  paths = [ prev.${pkg} ];
                  nativeBuildInputs = [ final.makeWrapper ];
                  postBuild = ''
                    rm $out/share/applications/${desktop}.desktop
                    substitute ${prev.${pkg}}/share/applications/${desktop}.desktop $out/share/applications/${desktop}.desktop \
                      --replace-quiet "${prev.${pkg}}" $out
                    wrapProgram $out/bin/${exe} --add-flags "--wayland-text-input-version=3"
                  '';
                };
              }
            )
            [
              {
                pkg = "qq";
                exe = "qq";
                desktop = "qq";
              }
              {
                pkg = "vscodium";
                exe = "codium";
                desktop = "codium";
              }
              {
                pkg = "signal-desktop";
                exe = "signal-desktop";
                desktop = "signal";
              }
            ]
        )
      )
      (
        final: prev:
        lib.mergeAttrsList (
          map
            (
              { pkg, desktops }:
              {
                ${pkg} = final.symlinkJoin {
                  name = prev.${pkg}.name;
                  paths = [ prev.${pkg} ];
                  postBuild = lib.concatLines (
                    map (
                      desktop:
                      ''
                        rm $out/share/applications/${desktop}.desktop
                        substitute ${prev.${pkg}}/share/applications/${desktop}.desktop $out/share/applications/${desktop}.desktop \
                          --replace-fail 'Exec=' 'Exec=env QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx '
                      ''
                    ) desktops
                  );
                };
              }
            )
            [
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
    my.hm.programs.niri.settings = {
      binds."Mod+Space".action.spawn = [
        "fcitx5-remote"
        "-t"
      ];
      spawn-at-startup = [ { command = [ "fcitx5" ]; } ];
    };
  };
}
