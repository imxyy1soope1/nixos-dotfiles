{ lib, ... }:
{
  options.my.desktop.browser.default = {
    command = lib.mkOption {
      type = lib.types.str;
      default = "chromium";
    };
    desktop = lib.mkOption {
      type = lib.types.str;
      default = "chromium-browser.desktop";
    };
  };
}
