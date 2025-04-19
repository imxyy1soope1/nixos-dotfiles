{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default zsh settings";
  optionPath = [
    "cli"
    "shell"
    "zsh"
  ];
  config' = {
    my.home =
      let
        stateHome = config.my.home.xdg.stateHome;
      in
      {
        home.packages = [ pkgs.omz ];
        programs.zsh = {
          enable = true;
          dotDir = ".config/zsh";
          history = {
            path = "${stateHome}/zsh_history";
            ignorePatterns = [
              "la"
            ];
          };
          initExtra = ''
            source ${pkgs.omz}/share/omz/omz.zsh
          '';
          sessionVariables = {
            _ZL_DATA = "${stateHome}/zlua";
            _FZF_HISTORY = "${stateHome}/fzf_history";
          };
          shellAliases = {
            ls = "lsd";
            svim = "sudoedit";
            nf = "neofetch";
            tmux = "tmux -T RGB,focus,overline,mouse,clipboard,usstyle";
            pastart = "pasuspender true";
          };
        };
      };
  };
}
