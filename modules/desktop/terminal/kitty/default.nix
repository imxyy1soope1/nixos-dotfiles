{ config, lib, ... }:
let
  cfg = config.my.desktop.terminal.kitty;
in
{
  options.my.desktop.terminal.kitty = {
    enable = lib.mkEnableOption "kitty";
  };

  config = lib.mkIf cfg.enable {
    my.hm.programs.kitty.enable = true;
    my.hm.programs.kitty = {
      settings = {
        cursor_blink_interval = 0;
        remember_window_size = "no";
        initial_window_width = 800;
        initial_window_height = 600;
        enable_audio_bell = "no";
        term = "xterm-256color";

        close_on_child_death = "yes";
      };
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
      };
      font = {
        name = "monospace";
        size = 14;
      };
      shellIntegration.mode = "no-cursor no-sudo";
      extraConfig = ''
        include ${./tokyonight-storm.conf}
      '';
    };
  };
}
