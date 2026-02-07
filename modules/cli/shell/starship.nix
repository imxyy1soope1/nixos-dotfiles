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
    (lib.mkIf cfg.enable {
      my.hm = {
        programs.starship = {
          enable = true;
          settings = lib.recursiveUpdate (with builtins; fromTOML (readFile ./starship-preset.toml)) {
            add_newline = false;
            command_timeout = 2000;
            nix_shell.disabled = true;
            format = let
              dedupDollar = list: let
                result = builtins.foldl' (acc: elem:
                  if lib.hasPrefix "$" elem then
                    if builtins.elem elem acc.seen
                    then acc
                    else acc // { result = acc.result ++ [elem]; seen = acc.seen ++ [elem]; }
                  else
                    acc // { result = acc.result ++ [elem]; }
                ) { result = []; seen = []; } (lib.reverseList list);
              in lib.reverseList result.result;
            in "$all" + lib.concatStrings (dedupDollar cfg.format);
          };
        };
      };
    })
  ];
}
