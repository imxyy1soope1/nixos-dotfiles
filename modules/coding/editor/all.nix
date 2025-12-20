{ config, lib, ... }:
let
  cfg = config.my.coding.editor.all;
in
{
  options.my.coding.editor.all = {
    enable = lib.mkEnableOption "all coding editors";
  };

  config = lib.mkIf cfg.enable {
    my.coding.editor = {
      neovim.enable = true;
      vscode.enable = true;
      zed.enable = true;
    };
  };
}
