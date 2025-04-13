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
        profiles.default = {
          extensions = with pkgs.open-vsx; [
            eamodio.gitlens
            rust-lang.rust-analyzer
            dbaeumer.vscode-eslint
          ];
        };
      };
    };
  };
}
