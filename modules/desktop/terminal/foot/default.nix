{ config, lib, ... }:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "foot";
  optionPath = [
    "desktop"
    "terminal"
    "foot"
  ];
  extraConfig = {
    my.home.programs.foot = {
      server.enable = true;
      settings = {
        main = {
          font = "monospace:size=14";
          initial-window-size-pixels = "800x600";
        };
        colors = {
          background = "24283b";
          foreground = "a9b1d6";
          regular0 = "32344a";
          regular1 = "f7768e";
          regular2 = "9ece6a";
          regular3 = "e0af68";
          regular4 = "7aa2f7";
          regular5 = "ad8ee6";
          regular6 = "449dab";
          regular7 = "9699a8";
          bright0 = "444b6a";
          bright1 = "ff7a93";
          bright2 = "b9f27c";
          bright3 = "ff9e64";
          bright4 = "7da6ff";
          bright5 = "bb9af7";
          bright6 = "0db9d7";
          bright7 = "acb0d0";
        };
      };
    };
  };
}
