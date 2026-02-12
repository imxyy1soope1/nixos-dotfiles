{ lib, ... }:
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
}
