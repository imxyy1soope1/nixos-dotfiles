{ config, lib, ... }:
let
  cfg = config.my.cli.shell.starship;
in
{
  options.my.cli.shell.starship = {
    enable = lib.mkEnableOption "starship prompt";
    format = lib.mkOption {
      type = with lib.types; listOf singleLineStr;
    };
  };

  config = lib.mkMerge [
    {
      my.cli.shell.starship.format = lib.mkOrder 0 [ "$all" ];
    }
    (lib.mkIf cfg.enable {
      my.hm = {
        programs.starship = {
          enable = true;
          settings = lib.recursiveUpdate (with builtins; fromTOML (readFile ./starship-preset.toml)) {
            add_newline = false;
            nix_shell.disabled = true;
            format = lib.concatStringsSep "" cfg.format;
          };
        };
      };
    })
  ];
}
