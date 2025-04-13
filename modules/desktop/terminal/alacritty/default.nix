{ config, lib, ... }:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "alacritty";
  optionPath = [
    "desktop"
    "terminal"
    "alacritty"
  ];
  extraConfig = {
    my.home.programs.alacritty.settings = {
      general.import = [ ./tokyonight-storm.toml ];
      cursor.style = {
        shape = "Block";
        blinking = "Never";
      };
      font.size = 14;
    };
  };
}
