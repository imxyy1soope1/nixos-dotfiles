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
      alacritty.enable = true;
      foot.enable = true;
      kitty.enable = true;
      ghostty.enable = true;
    };
  };
}
