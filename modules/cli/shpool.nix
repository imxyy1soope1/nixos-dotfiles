{
  config,
  lib,
  ...
}:
let
  cfg = config.my.cli.shpool;
in
{
  options.my.cli.shpool = {
    enable = lib.mkEnableOption "shpool";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      services.shpool = {
        enable = true;
        systemd = true;
        settings = {
          motd = "never";
          prompt_prefix = "";
          forward_env = [ "PATH" ];
        };
      };
      programs.starship = {
        settings = {
          custom.shpool = {
            description = "Display current shpool session name";
            when = ''test -n "$SHPOOL_SESSION_NAME"'';
            command = "echo $SHPOOL_SESSION_NAME";
            symbol = " ";
            style = "fg:#dea584";
            format = "[$symbol \\[$output\\] ]($style)";
          };
        };
      };
    };
    my.cli.shell.starship.format = [ "\${custom.shpool}" "$character" ];
  };
}
