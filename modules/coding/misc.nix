{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.misc;
in
{
  options.my.coding.misc = {
    enable = lib.mkEnableOption "misc";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      home.packages = with pkgs; [
        just
        gnumake
        github-cli # gh
      ];
      programs.starship.settings = {
        nix_shell.disabled = true;
        # direnv =
        #   let
        #     esc = builtins.fromJSON ''"\u001b"'';
        #   in
        #   {
        #     disabled = false;
        #     format = "$loaded$allowed ";
        #     loaded_msg = "${esc}[1;92m ${esc}[0m"; # green
        #     unloaded_msg = "";
        #     allowed_msg = "";
        #     not_allowed_msg = "${esc}[1;93m ${esc}[0m"; # yellow
        #     denied_msg = "${esc}[1;91m ${esc}[0m"; # red
        #   };
      };
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        config = {
          global = {
            warn_timeout = 0;
            hide_env_diff = false;
          };
        };
        stdlib = lib.mkAfter ''
          if [[ -f .envrc.local && -z "$DIRENV_LOCAL_LOADED" ]]; then
            export DIRENV_LOCAL_LOADED=1
            log_status ".envrc.local detected, loading..."

            skip_default_envrc() {
              log_status "skip_default_envrc triggered, skipping .envrc"
              exit 0
            }

            source_env .envrc.local

            use() {
              log_status "intercepted 'use $@' in .envrc"
            }
          fi
        '';
      };
    };
    my.persist.homeDirs = [
      ".config/gh"
      ".local/share/direnv"
    ];
  };
}
