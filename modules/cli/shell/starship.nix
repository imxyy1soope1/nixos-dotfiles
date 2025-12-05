{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "starship prompt";
  optionPath = [
    "cli"
    "shell"
    "starship"
  ];
  config' = {
    my.hm = {
      programs.starship = {
        enable = true;
        settings = lib.recursiveUpdate (with builtins; fromTOML (readFile ./starship-preset.toml)) {
          add_newline = false;
          nix_shell.disabled = true;
        };
      };
    };
  };
}
