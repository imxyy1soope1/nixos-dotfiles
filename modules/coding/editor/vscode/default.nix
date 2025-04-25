{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "neovim";
  optionPath = [
    "coding"
    "editor"
    "vscode"
  ];
  extraConfig = {
    my.home = {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
      };
    };
    my.persist.homeDirs = [
      ".config/VSCodium"
    ];
  };
}
