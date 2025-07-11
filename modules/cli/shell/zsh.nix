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
    my.persist.homeDirs = [ ".local/share/zoxide" ];
    my.home =
      let
        stateHome = config.my.home.xdg.stateHome;
        zsh-syntax-highlighting = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
        fzf-tab = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.2.0";
          hash = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
        };
      in
      {
        home.packages = with pkgs; [
          fzf
          zoxide
        ];
        programs.starship = {
          enable = true;
          settings = lib.recursiveUpdate (with builtins; fromTOML (readFile ./starship-preset.toml)) {
            add_newline = false;
            custom = {
              jj = {
                ignore_timeout = true;
                description = "The current jj status";
                when = "jj root";
                symbol = " ";
                command = ''
                  jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
                    separate(" ",
                      change_id.shortest(4),
                      bookmarks,
                      "|",
                      concat(
                        if(conflict, "💥"),
                        if(divergent, "🚧"),
                        if(hidden, "👻"),
                        if(immutable, "🔒"),
                      ),
                      raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                      raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                        truncate_end(29, description.first_line(), "…"),
                        "(no description set)",
                      ) ++ raw_escape_sequence("\x1b[0m"),
                    )
                  '
                '';
              };
              git_branch = {
                when = true;
                command = "jj root >/dev/null 2>&1 || starship module git_branch";
                description = "Only show git_branch if we're not in a jj repo";
              };
              git_status = {
                when = true;
                command = "jj root >/dev/null 2>&1 || starship module git_status";
                description = "Only show git_status if we're not in a jj repo";
              };
            };
            git_state.disabled = true;
            git_commit.disabled = true;
            git_metrics.disabled = true;
            git_branch.disabled = true;
            git_status.disabled = true;
            nix_shell.disabled = true;
          };
        };
        programs.zsh = {
          enable = true;
          dotDir = ".config/zsh";
          history = {
            path = "${stateHome}/zsh_history";
            ignorePatterns = [
              "la"
            ];
          };
          initContent = lib.mkAfter ''
            source ${fzf-tab}/fzf-tab.plugin.zsh

            eval "$(zoxide init zsh)"
            source ${zsh-syntax-highlighting}/zsh-syntax-highlighting.plugin.zsh
            source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          '';
          oh-my-zsh = {
            enable = true;
            theme = "gentoo";
            plugins = [
              "git"
              "git-extras"
              "extract"
              "sudo"
              "dotenv"
            ];
          };
          shellAliases = {
            x = "extract";
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
