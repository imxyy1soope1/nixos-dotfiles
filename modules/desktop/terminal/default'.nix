{ lib, ... }:
{
  options.my.desktop.terminal.default = {
    command = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
    };
    desktop = lib.mkOption {
      type = lib.types.str;
      default = "kitty.desktop";
    };
  };
}
