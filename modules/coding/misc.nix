{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.misc;
in
{
  options.my.coding.misc = {
    enable = lib.mkEnableOption "misc";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      home.packages = with pkgs; [
        gnumake
        github-cli # gh
      ];
      programs.direnv = {
        enable = true;
        config = {
          global = {
            warn_timeout = 0;
            hide_env_diff = false;
          };
        };
      };
    };
    my.persist.homeDirs = [
      ".local/share/direnv"
    ];
  };
}
