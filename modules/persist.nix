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
    location = lib.mkOption {
      type = lib.types.str;
      example = lib.literalExpression ''
        "/persistent"
      '';
      description = lib.mdDoc ''
        Persistent location
      '';
    };
    homeDirs = lib.mkOption {
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
    environment.persistence.${cfg.location} = {
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
