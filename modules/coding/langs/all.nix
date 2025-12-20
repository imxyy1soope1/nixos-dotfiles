{ config, lib, ... }:
let
  cfg = config.my.coding.langs.all;
in
{
  options.my.coding.langs.all = {
    enable = lib.mkEnableOption "all coding langs";
  };

  config = lib.mkIf cfg.enable {
    my.coding.langs = {
      c.enable = true;
      go.enable = true;
      js.enable = true;
      python.enable = true;
      rust.enable = true;
      lua.enable = true;
      java.enable = true;
      qml.enable = true;
      typst.enable = true;
    };
  };
}
