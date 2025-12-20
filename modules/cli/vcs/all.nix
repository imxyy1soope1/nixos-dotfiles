{ config, lib, ... }:
let
  cfg = config.my.cli.vcs.all;
in
{
  options.my.cli.vcs.all = {
    enable = lib.mkEnableOption "all command line tools";
  };

  config = lib.mkIf cfg.enable {
    my.cli.vcs = {
      git.enable = true;
      jj.enable = true;
    };
  };
}
