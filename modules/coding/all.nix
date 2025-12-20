{ config, lib, ... }:
let
  cfg = config.my.coding.all;
in
{
  options.my.coding.all = {
    enable = lib.mkEnableOption "all coding tools";
  };

  config = lib.mkIf cfg.enable {
    my.coding = {
      editor.all.enable = true;
      langs.all.enable = true;
      misc.enable = true;
    };
  };
}
