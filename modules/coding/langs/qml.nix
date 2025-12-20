{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.qml;
in
{
  options.my.coding.langs.qml = {
    enable = lib.mkEnableOption "QML";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      kdePackages.qtdeclarative
    ];
  };
}
