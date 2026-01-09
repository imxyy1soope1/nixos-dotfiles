{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.shell.fish;
in
{
  options.my.cli.shell.fish = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable default fish settings";
    };
  };

  config = lib.mkIf cfg.enable {
    my.persist = {
      homeDirs = [
        ".local/share/fish"
      ];
    };
    my.hm = {
      xdg.configFile."fish/themes/tokyonight_storm.theme".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/tags/v4.14.1/extras/fish_themes/tokyonight_storm.theme";
        sha256 = "02n1w5x65683c8mlwg1rav06iqm3xk90zq45qmygpm7pzyn8dqh1";
      };
      programs.starship.enableFishIntegration = false;
      programs.fish = {
        enable = true;
        plugins = [
          {
            name = "extract";
            src = pkgs.fetchFromGitHub {
              owner = "hexclover";
              repo = "fish-extract-ng";
              tag = "v0.1";
              hash = "sha256-yef5NX4HdZ3ab/2AzNrvvhi0CbeTvXYKZmyH76gIpyk=";
            };
          }
        ];
        shellAliases = {
          la = "lsd -lah";
          ls = "lsd";
          svim = "doasedit";
          nf = "fastfetch";
        };
        interactiveShellInit = lib.mkBefore ''
          fish_vi_key_bindings
          fish_config theme choose tokyonight_storm
          ${lib.optionalString config.my.cli.shell.starship.enable "source ${./starship.fish}"}
        '';
        functions = {
          fish_greeting = "";
          yank_to_clipboard = {
            description = "Insert latest killring entry into the system clipboard";
            body = ''printf "%s" "$fish_killring[1]" | fish_clipboard_copy'';
          };
          fish_user_key_bindings = ''
            # make vi mode yanks copy to clipboard
            bind yy kill-whole-line yank_to_clipboard yank
            bind Y kill-whole-line yank_to_clipboard yank
            bind y,\$ kill-line yank_to_clipboard yank
            bind y,\^ backward-kill-line yank_to_clipboard yank
            bind y,0 backward-kill-line yank_to_clipboard yank
            bind y,w kill-word yank_to_clipboard yank
            bind y,W kill-bigword yank_to_clipboard yank
            bind y,i,w forward-single-char forward-single-char backward-word kill-word yank_to_clipboard yank
            bind y,i,W forward-single-char forward-single-char backward-bigword kill-bigword yank_to_clipboard yank
            bind y,a,w forward-single-char forward-single-char backward-word kill-word yank_to_clipboard yank
            bind y,a,W forward-single-char forward-single-char backward-bigword kill-bigword yank_to_clipboard yank
            bind y,e kill-word yank_to_clipboard yank
            bind y,E kill-bigword yank_to_clipboard yank
            bind y,b backward-kill-word yank_to_clipboard yank
            bind y,B backward-kill-bigword yank_to_clipboard yank
            bind y,g,e backward-kill-word yank_to_clipboard yank
            bind y,g,E backward-kill-bigword yank_to_clipboard yank
            bind y,f begin-selection forward-jump kill-selection yank_to_clipboard yank end-selection
            bind y,t begin-selection forward-jump-till kill-selection yank_to_clipboard yank end-selection
            bind y,F begin-selection backward-jump kill-selection yank_to_clipboard yank end-selection
            bind y,T begin-selection backward-jump-till kill-selection yank_to_clipboard yank end-selection
            bind y,h backward-char begin-selection kill-selection yank_to_clipboard yank end-selection
            bind y,l begin-selection kill-selection yank_to_clipboard yank end-selection
            bind y,i,b jump-till-matching-bracket and jump-till-matching-bracket and begin-selection jump-till-matching-bracket kill-selection yank_to_clipboard yank end-selection
            bind y,a,b jump-to-matching-bracket and jump-to-matching-bracket and begin-selection jump-to-matching-bracket kill-selection yank_to_clipboard yank end-selection
            bind y,i backward-jump-till and repeat-jump-reverse and begin-selection repeat-jump kill-selection yank_to_clipboard yank end-selection
            bind y,a backward-jump and repeat-jump-reverse and begin-selection repeat-jump kill-selection yank_to_clipboard yank end-selection
            bind -M visual -m default y kill-selection yank_to_clipboard yank end-selection repaint-mode

            # use system clipboard for vi mode pastes
            bind -s p 'set -g fish_cursor_end_mode exclusive' forward-char 'set -g fish_cursor_end_mode inclusive' fish_clipboard_paste
            bind -s P fish_clipboard_paste
          '';

          nix-closure-size = {
            body = ''
              nix path-info --recursive --size --closure-size \
                            --human-readable $(readlink -f $(which $program))
            '';
            argumentNames = [ "program" ];
          };
        };
      };
    };
  };
}
