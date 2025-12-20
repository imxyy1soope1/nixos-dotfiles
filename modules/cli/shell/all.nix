{ config, lib, ... }:
let
  cfg = config.my.cli.shell.all;
in
{
  options.my.cli.shell.all = {
    enable = lib.mkEnableOption "all shells";
  };

  config = lib.mkIf cfg.enable {
    my.cli.shell = {
      zsh.enable = true;
      fish.enable = true;
      starship.enable = true;
    };
  };
}
