{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.my.cli.shell;
in
{
  options.my.cli.shell.default = lib.mkOption {
    type = lib.types.enum [
      "fish"
      "zsh"
    ];
    default = "fish";
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.default == "fish") {
      my.cli.shell.fish.enable = true;
      users.users.${username} = {
        shell = config.my.hm.programs.fish.package;
        # do not need `programs.fish.enable = true` since fish is managed by home-manager
        ignoreShellProgramCheck = true;
      };
    })

    (lib.mkIf (cfg.default == "zsh") {
      my.cli.shell.zsh.enable = true;
      users.users.${username}.shell = config.my.hm.programs.zsh.package;
    })
  ];
}
