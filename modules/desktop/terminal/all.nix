{ config, lib, ... }:
let
  cfg = config.my.desktop.terminal.all;
in
{
  options.my.desktop.terminal.all = {
    enable = lib.mkEnableOption "all terminals";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.terminal = {
      alacritty.enable = false;
      foot.enable = false;
      kitty.enable = true;
      ghostty.enable = false;
    };
  };
}
