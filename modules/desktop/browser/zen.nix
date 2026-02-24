{
  config,
  lib,
  pkgs,
  hostname,
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
    assertions = [
      {
        assertion = hostname == "imxyy-nix";
        message = "XDG migration not done! Check
        https://github.com/0xc000022070/zen-browser-flake?tab=readme-ov-file#missing-configuration-after-update
          for details";
      }
    ];

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
      ".config/zen"
    ];
  };
}
