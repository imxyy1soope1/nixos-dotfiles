{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.typst;
in
{
  options.my.coding.langs.typst = {
    enable = lib.mkEnableOption "Typst";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      typst
      tinymist
    ];
  };
}
