{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.python;
in
{
  options.my.coding.langs.python = {
    enable = lib.mkEnableOption "python3";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      python3
      uv
      pyright
    ];
  };
}
