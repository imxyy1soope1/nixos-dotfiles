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
        ];
      };
  };
}
