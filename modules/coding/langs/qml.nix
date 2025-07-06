{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "QML";
  optionPath = [
    "coding"
    "langs"
    "qml"
  ];
  config' = {
    my.home.home.packages = with pkgs; [
      kdePackages.qtdeclarative
    ];
  };
}
