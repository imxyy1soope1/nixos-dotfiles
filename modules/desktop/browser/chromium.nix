{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "chromium";
  optionPath = [
    "desktop"
    "browser"
    "chromium"
  ];
  extraConfig = {
    my.home.programs.chromium = {
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
          id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh"; # Immersive Translate
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
  };
}
