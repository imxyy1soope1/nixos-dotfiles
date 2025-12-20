{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.langs.java;
in
{
  options.my.coding.langs.java = {
    enable = lib.mkEnableOption "java";
  };

  config = lib.mkIf cfg.enable {
    my.hm.home.packages = with pkgs; [
      openjdk25
      java-language-server
    ];
  };
}
