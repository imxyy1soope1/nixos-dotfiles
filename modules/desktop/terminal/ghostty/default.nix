{ config, lib, ... }:
let
  cfg = config.my.desktop.terminal.ghostty;
in
{
  options.my.desktop.terminal.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };

  config = lib.mkIf cfg.enable {
    my.hm.programs.ghostty.enable = true;
    my.hm.programs.ghostty = {
      enableBashIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = true;
      settings = {
        font-size = 14;
        theme = "${./tokyonight-storm}";
      };
    };
  };
}
