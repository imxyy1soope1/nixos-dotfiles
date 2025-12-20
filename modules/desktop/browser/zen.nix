{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.browser.zen;
in
{
  options.my.desktop.browser.zen = {
    enable = lib.mkEnableOption "zen-browser";
  };

  config = lib.mkIf cfg.enable {
    my.hm.programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
      policies = {
        # find more options here: https://mozilla.github.io/policy-templates/
        DisableAppUpdate = true;
        DisableTelemetry = true;
      };
    };
    my.persist.homeDirs = [
      ".zen"
    ];
  };
}
