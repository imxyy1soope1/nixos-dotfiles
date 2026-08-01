{ lib, config, ... }:
let
  cfg = config.my.desktop.browser.default;
  desktop = [ cfg.desktop ];
in
{
  options.my.desktop.browser.default = {
    command = lib.mkOption {
      type = lib.types.str;
      default = "zen-beta";
    };
    desktop = lib.mkOption {
      type = lib.types.str;
      default = "zen-beta.desktop";
    };
  };

  config = {
    my.xdg.defaultApplications = {
      "text/html" = desktop;
      "x-scheme-handler/about" = desktop;
      "x-scheme-handler/ftp" = desktop;
      "x-scheme-handler/http" = desktop;
      "x-scheme-handler/https" = desktop;
      "x-scheme-handler/unknown" = desktop;
    };
  };
}
