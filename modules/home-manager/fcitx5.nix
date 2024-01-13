{ config, pkgs, lib, ... }:

with lib;

let
  im = config.i18n.inputMethod;
  cfg = im.fcitx5;
  fcitx5Package = pkgs.fcitx5-with-addons.override { inherit (cfg) addons; };
  settingsFormat = pkgs.formats.ini { };
in
{
  disabledModules = [ "i18n/input-method/fcitx5.nix" ];
  options = {
    i18n.inputMethod.fcitx5 = {
      addons = mkOption {
        type = with types; listOf package;
        default = [ ];
        example = literalExpression "with pkgs; [ fcitx5-rime ]";
        description = lib.mdDoc ''
          Enabled Fcitx5 addons.
        '';
      };
      waylandFrontend = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Use the Wayland input method frontend.
          See [Using Fcitx 5 on Wayland](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland).
        '';
      };
      quickPhrase = mkOption {
        type = with types; attrsOf str;
        default = { };
        example = literalExpression ''
          {
            smile = "（・∀・）";
            angry = "(￣ー￣)";
          }
        '';
        description = lib.mdDoc "Quick phrases.";
      };
      quickPhraseFiles = mkOption {
        type = with types; attrsOf path;
        default = { };
        example = literalExpression ''
          {
            words = ./words.mb;
            numbers = ./numbers.mb;
          }
        '';
        description = lib.mdDoc "Quick phrase files.";
      };
      settings = {
        globalOptions = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;
          };
          default = { };
          description = lib.mdDoc ''
            The global options in `config` file in ini format.
          '';
        };
        inputMethod = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;
          };
          default = { };
          description = lib.mdDoc ''
            The input method configure in `profile` file in ini format.
          '';
        };
        addons = lib.mkOption {
          type = with lib.types; (attrsOf anything);
          default = { };
          description = lib.mdDoc ''
            The addon configures in `conf` folder in ini format with global sections.
            Each item is written to the corresponding file.
          '';
          example = literalExpression "{ pinyin.globalSection.EmojiEnabled = \"True\"; }";
        };
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "i18n" "inputMethod" "fcitx5" "enableRimeData" ] ''
      RIME data is now included in `fcitx5-rime` by default, and can be customized using `fcitx5-rime.override { rimeDataPkgs = ...; }`
    '')
  ];

  config = mkIf (im.enabled == "fcitx5") {
    i18n.inputMethod.package = fcitx5Package;

    i18n.inputMethod.fcitx5.addons = lib.optionals (cfg.quickPhrase != { }) [
      (pkgs.writeTextDir "share/fcitx5/data/QuickPhrase.mb"
        (lib.concatStringsSep "\n"
          (lib.mapAttrsToList (name: value: "${name} ${value}") cfg.quickPhrase)))
    ] ++ lib.optionals (cfg.quickPhraseFiles != { }) [
      (pkgs.linkFarm "quickPhraseFiles" (lib.mapAttrs'
        (name: value: lib.nameValuePair ("share/fcitx5/data/quickphrase.d/${name}.mb") value)
        cfg.quickPhraseFiles))
    ];

    xdg.configFile =
      let
        optionalFile = p: f: v: lib.optionalAttrs (v != { }) {
          "fcitx5/${p}".text = f v;
        };
      in
      lib.attrsets.mergeAttrsList [
        (optionalFile "profile" (lib.generators.toINI { }) cfg.settings.inputMethod)
        (optionalFile "config" (lib.generators.toINI { }) cfg.settings.globalOptions)
        (lib.concatMapAttrs
          (name: value: optionalFile
            "conf/${name}.conf"
            (lib.generators.toINIWithGlobalSection { })
            value)
          cfg.settings.addons)
      ];

    home.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      QT_PLUGIN_PATH = "$QT_PLUGIN_PATH\${QT_PLUGIN_PATH:+:}${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}";
    } // lib.optionalAttrs (!cfg.waylandFrontend) {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
    };
  };
}
