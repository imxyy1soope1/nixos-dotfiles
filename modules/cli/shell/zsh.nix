{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.shell.zsh;
in
{
  options.my.cli.shell.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable default zsh settings";
    };
  };

  config = lib.mkIf cfg.enable {
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
        };
      };
    };
  };
}
