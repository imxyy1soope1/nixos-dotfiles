{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "vscode";
  optionPath = [
    "coding"
    "editor"
    "vscode"
  ];
  extraConfig = {
    my.home = {
      programs.vscode = {
        package = pkgs.vscodium;
      };
    };
    my.persist.homeDirs = [
      ".config/VSCodium"
      ".vscode-oss"
    ];
  };
}
