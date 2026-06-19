{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.toml;
in
{
  options.my.coding.langs.toml = {
    enable = lib.mkEnableOption "TOML";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      tombi
    ];
  };
}
