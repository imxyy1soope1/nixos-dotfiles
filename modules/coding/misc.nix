{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "misc";
  optionPath = [
    "coding"
    "misc"
  ];
  config' = {
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
