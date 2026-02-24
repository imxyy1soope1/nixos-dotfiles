{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.editor.vscode;
in
{
  options.my.coding.editor.vscode = {
    enable = lib.mkEnableOption "vscode";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      programs.vscodium.enable = true;
    };
    my.persist.homeDirs = [
      ".config/VSCodium"
      ".vscode-oss"
    ];
  };
}
