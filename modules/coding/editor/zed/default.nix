{
  config,
  lib,
  ...
}:
let
  cfg = config.my.coding.editor.zed;
in
{
  options.my.coding.editor.zed = {
    enable = lib.mkEnableOption "zed-editor";
  };

  config = lib.mkIf cfg.enable {
    my.hm.programs.zed-editor.enable = true;
    my.persist.homeDirs = [
      ".config/zed"
      ".local/share/zed"
    ];
  };
}
