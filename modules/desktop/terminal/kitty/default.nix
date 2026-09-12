{
  config,
  lib,
  live,
  ...
}:
let
  cfg = config.my.desktop.terminal.kitty;
in
{
  options.my.desktop.terminal.kitty = {
    enable = lib.mkEnableOption "kitty";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      xdg.configFile."kitty".source = live.mkLiveLink ./config;
      xdg.configFile."kitty/kitty.conf".target = "kitty-generated.conf";
      programs.kitty.enable = true;
    };
    my.hm.programs.kitty = {
      shellIntegration.mode = "no-cursor no-sudo";
    };
  };
}
