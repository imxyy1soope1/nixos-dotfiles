{ config, lib, ... }:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "kitty";
  optionPath = [
    "desktop"
    "terminal"
    "kitty"
  ];
  extraConfig = {
    my.home.programs.kitty = {
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
      extraConfig = ''
        include ${./tokyonight-storm.conf}
      '';
    };
  };
}
