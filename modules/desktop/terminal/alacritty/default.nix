{ config, lib, ... }:
let
  cfg = config.my.desktop.terminal.alacritty;
in
{
  options.my.desktop.terminal.alacritty = {
    enable = lib.mkEnableOption "alacritty";
  };

  config = lib.mkIf cfg.enable {
    my.hm.programs.alacritty.enable = true;
    my.hm.programs.alacritty.settings = {
      general.import = [ ./tokyonight-storm.toml ];
      cursor.style = {
        shape = "Block";
        blinking = "Never";
      };
      font.size = 14;
    };
  };
}
