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
    my.hm.home.packages = with pkgs; [
      kdePackages.qtdeclarative
    ];
  };
}
