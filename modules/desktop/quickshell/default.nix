{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = false;
  optionName = "quickshell";
  optionPath = [
    "desktop"
    "quickshell"
  ];
  config' = {
    my.home = {
      home.packages = [ pkgs.quickshell ];
      home.sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
        "${pkgs.quickshell}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
        "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      ];
      xdg.configFile."quickshell" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
