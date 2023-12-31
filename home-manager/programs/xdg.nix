{ config, ... }: {
  xdg =
    let
      homedir = config.home.homeDirectory;
    in
    {
      enable = true;

      cacheHome = "${homedir}/.cache";
      configHome = "${homedir}/.config";
      dataHome = "${homedir}/.local/share";
      stateHome = "${homedir}/.local/state";

      userDirs.enable = true;
    };
}
