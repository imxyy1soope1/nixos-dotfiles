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
    my.hm = {
      home.packages = with pkgs; [
        fzf
      ];
      programs.zsh = {
        enable = true;
        dotDir = "${config.my.hm.xdg.configHome}/zsh";
        history = {
          path = "${config.my.hm.xdg.stateHome}/zsh_history";
          ignorePatterns = [
            "la"
          ];
        };
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "fzf-tab";
            src = pkgs.zsh-fzf-tab;
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
          }
        ];
        oh-my-zsh = {
          enable = true;
          theme = "gentoo";
          plugins = [
            "git"
            "git-extras"
            "extract"
            "sudo"
          ];
        };
        shellAliases = {
          x = "extract";
          ls = "lsd";
          svim = "doasedit";
          nf = "fastfetch";
          tmux = "tmux -T RGB,focus,overline,mouse,clipboard,usstyle";
        };
      };
    };
  };
}
