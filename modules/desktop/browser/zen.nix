{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "zen-browser";
  optionPath = [
    "desktop"
    "browser"
    "zen"
  ];
  extraConfig = {
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
