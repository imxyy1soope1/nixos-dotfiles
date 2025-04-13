{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.my.persist;
in
{
  options.my.persist = {
    enable = lib.mkEnableOption "persist";
    homeDirs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''
        [
          ".minecraft"
          ".cargo"
        ]
      '';
      description = lib.mdDoc ''
        HomeManager persistent dirs.
      '';
    };
    nixosDirs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''
        [
          "/root"
          "/var"
        ]
      '';
      description = lib.mdDoc ''
        NixOS persistent dirs.
      '';
    };
    homeFiles = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''
        [
          ".hmcl.json"
        ]
      '';
      description = lib.mdDoc ''
        Persistent files.
      '';
    };
    nixosFiles = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''
        [
          "/etc/machine-id"
        ]
      '';
      description = lib.mdDoc ''
        Persistent files.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fuse.userAllowOther = true;
    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = cfg.nixosDirs;
      files = cfg.nixosFiles;
      users.${username} = {
        files = cfg.homeFiles;
        directories = cfg.homeDirs;
      };
    };
  };
}
