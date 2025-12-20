{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.go;
in
{
  options.my.coding.langs.go = {
    enable = lib.mkEnableOption "go";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      go
      gotools
      gopls
    ];
    my.persist.homeDirs = [
      "go"
    ];
  };
}
