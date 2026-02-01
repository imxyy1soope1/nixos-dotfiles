{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.tmux;
in
{
  options.my.cli.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      programs.tmux = {
        enable = true;
        extraConfig = ''
          set-option -g mouse on
          set-option -a terminal-features ",xterm-256color:RGB,focus,clipboard,usstyle"
        '';
        plugins = [
          (pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "tokyo-night-tmux";
            rtpFilePath = "tokyo-night.tmux";
            version = "legacy";
            src = pkgs.fetchFromGitHub {
              owner = "janoamaral";
              repo = "tokyo-night-tmux";
              rev = "16469dfad86846138f594ceec780db27039c06cd";
              hash = "sha256-EKCgYan0WayXnkSb2fDJxookdBLW0XBKi2hf/YISwJE=";
            };
          })
        ];
      };
      # https://github.com/starship/starship/discussions/7260
      # programs.starship = {
      #   settings = {
      #     custom.tmux = {
      #       description = "Display current tmux session name";
      #       when = ''test -n "$TMUX"'';
      #       command = "tmux display-message -p '#S'";
      #       symbol = " ";
      #       style = "bold green";
      #       format = "[$symbol $output]($style)";
      #     };
      #   };
      # };
    };
    # my.cli.shell.starship.format = [ "$tmux$character" ];
  };
}
