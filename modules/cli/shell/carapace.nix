{ config, lib, ... }:
let
  cfg = config.my.cli.shell.carapace;
in
{
  options.my.cli.shell.carapace = {
    enable = lib.mkEnableOption "carapace completer";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      programs.carapace = {
        enable = true;
      };
    };
  };
}
