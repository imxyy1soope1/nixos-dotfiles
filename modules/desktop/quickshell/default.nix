{
  config,
  lib,
  pkgs,
  ...
}:
let
  # FIXME: symlink
  homeDir = config.my.home.home.homeDirectory;
  quickshellDir = "${homeDir}/workspace/nixos-dotfiles/modules/desktop/quickshell/qml";
  quickshellTarget = "${homeDir}/.config/quickshell";
in
lib.my.makeSwitch {
  inherit config;
  default = false;
  optionName = "quickshell";
  optionPath = [
    "desktop"
    "quickshell"
  ];
  config' = {
    my.home.home = {
      packages = with pkgs; [
        quickshell
        qt6Packages.qt5compat
        libsForQt5.qt5.qtgraphicaleffects
        kdePackages.qtbase
        kdePackages.qtdeclarative

        material-symbols
        material-icons
      ];
      sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
        "${pkgs.quickshell}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
        "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      ];
      activation.symlinkQuickshellAndFaceIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfn "${quickshellDir}" "${quickshellTarget}"
      '';
    };
  };
}
