{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.browser.chromium;
in
{
  options.my.desktop.browser.chromium = {
    enable = lib.mkEnableOption "chromium";
  };

  config = lib.mkIf cfg.enable {
    my.hm.programs.chromium.enable = true;
    my.hm.programs.chromium = {
      package = pkgs.ungoogled-chromium;
      extensions = [
        {
          id = "jokpcbcafcbkjgcbjdcbadhfhimkafab"; # BitWarden
        }
        {
          id = "ipgcaebkhediiaeinmmaneoehfjpjkle"; # Dark Reader
        }
        {
          id = "leehfofbonhkmfimcelojmjnccdfemhl"; # New Tab
        }
        {
          id = "padekgcemlokbadohgkifijomclgjgif"; # SwitchyOmega
        }
        {
          id = "bgnkhhnnamicmpeenaelnjfhikgbkllg"; # AdGuard
        }
        {
          id = "ocaahdebbfolfmndjeplogmgcagdmblk"; # Web Store
        }
        {
          id = "pinabllndpmfdcknifcfcmdgdngjcfii"; # Firefox Dark Theme
        }
        {
          id = "bdiifdefkgmcblbcghdlonllpjhhjgof"; # KISS Translator
        }
        {
          id = "fnaicdffflnofjppbagibeoednhnbjhg"; # Floccus Bookmarks Sync
        }
      ];
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    };
    my.persist.homeDirs = [
      ".config/chromium"
    ];
  };
}
