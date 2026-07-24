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
    my.hm =
      let
        homedir = config.my.hm.home.homeDirectory;
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

          userDirs = {
            enable = true;
            setSessionVariables = true;
          };

          configFile."mimeapps.list".force = true;

          mimeApps = {
            enable = true;
            inherit (cfg) defaultApplications;
          };
        };
        gtk.gtk3.bookmarks = [
          "file://${homedir}/Documents Documents"
          "file://${homedir}/Downloads Downloads"
          "file://${homedir}/Pictures Pictures"
          "file://${homedir}/Videos Videos"
          "file://${homedir}/Music Music"
          "file://${homedir}/workspace Workspace"
        ];
      };
  };
}
