{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.media.splayer;
in
{
  options.my.desktop.media.splayer = {
    enable = lib.mkEnableOption "splayer";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = (
      lib.warn
        ''
          SPlayer still using pnpm 10.29.2. Check
          https://github.com/NixOS/nixpkgs/issues/535580#issuecomment-4809489104
        ''
        [
          "pnpm-10.29.2"
        ]
    );

    my.hm.home.packages = [
      # (pkgs.master.splayer.override {
      #   pnpm_10_29_2 = pkgs.pnpm_10;
      # })
      pkgs.splayer
    ];
    my.persist.homeDirs = [
      ".config/SPlayer"
    ];
  };
}
