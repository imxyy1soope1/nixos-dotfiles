{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my.xdg;
in
{
  options.my.xdg = {
    enable = lib.mkEnableOption "xdg";
    defaultApplications = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    extraBookmarks = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    my.home =
      let
        homedir = config.my.home.home.homeDirectory;
      in
      {
        home.packages = with pkgs; [
          xdg-utils # `xdg-mime` `xdg-open` and so on
        ];
        xdg = {
          enable = true;

          cacheHome = "${homedir}/.cache";
          configHome = "${homedir}/.config";
          dataHome = "${homedir}/.local/share";
          stateHome = "${homedir}/.local/state";

          userDirs.enable = true;

          configFile."mimeapps.list".force = true;

          mimeApps = {
            enable = true;
            inherit (cfg) defaultApplications;
          };
        };
        gtk.gtk3.bookmarks = [
          "file://${homedir}/Documents 文档"
          "file://${homedir}/Downloads 下载"
          "file://${homedir}/Pictures 图片"
          "file://${homedir}/Videos 视频"
          "file://${homedir}/Music 音乐"
          "file://${homedir}/workspace 工作空间"
          "file://${homedir}/Documents/%E7%8F%AD%E7%BA%A7%E4%BA%8B%E5%8A%A1 班级事务"
          "file://${homedir}/NAS NAS"
          "file://${homedir}/NAS/imxyy_soope_ NAS imxyy_soope_"
          "file://${homedir}/NAS/imxyy_soope_/OS NAS OS"
        ];
      };
  };
}
