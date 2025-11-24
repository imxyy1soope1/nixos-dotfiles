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
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium-wayland or pkgs.vscodium;
      };
    };
    my.persist.homeDirs = [
      ".config/VSCodium"
      ".vscode-oss"
    ];
  };
}
