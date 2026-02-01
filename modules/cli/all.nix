{ config, lib, ... }:
let
  cfg = config.my.cli.all;
in
{
  options.my.cli.all = {
    enable = lib.mkEnableOption "all command line tools";
  };

  config = lib.mkIf cfg.enable {
    my.cli = {
      media.all.enable = true;
      misc.enable = true;
      monitor.all.enable = true;
      shell.all.enable = true;
      vcs.all.enable = true;

      shpool.enable = true;
      tmux.enable = true;
    };
  };
}
