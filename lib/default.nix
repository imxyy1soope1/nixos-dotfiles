{ lib }:

{
  makeSwitch =
    {
      default ? false,
      config,
      optionPath,
      optionName,
      config',
    }:
    let
      cfg = lib.getAttrFromPath optionPath config.my;
    in
    {
      options.my = lib.setAttrByPath (optionPath) {
        enable = (lib.mkEnableOption optionName) // {
          inherit default;
        };
      };

      config = lib.mkIf cfg.enable config';
    };

  makeHomePackageConfig =
    {
      config,
      pkgs,
      packageName,
      packagePath,
      optionPath,
      extraConfig ? { },
    }:
    lib.my.makeSwitch {
      inherit config optionPath;
      optionName = packageName;
      config' = lib.mkMerge [
        {
          my.home.home.packages = [ (lib.getAttrFromPath packagePath pkgs) ];
        }
        extraConfig
      ];
    };

  makeHomeProgramConfig =
    {
      config,
      programName,
      optionPath,
      extraConfig ? { },
    }:
    lib.my.makeSwitch {
      inherit config optionPath;
      optionName = programName;

      config' = lib.mkMerge [
        {
          my.home.programs = lib.setAttrByPath [ programName "enable" ] true;
        }
        extraConfig
      ];
    };

  makeNixosPackageConfig =
    {
      config,
      pkgs,
      packageName,
      packagePath,
      optionPath,
      extraConfig ? { },
    }:
    lib.my.makeSwitch {
      inherit config optionPath;
      optionName = packageName;
      config' = lib.mkMerge [
        {
          environment.systemPackages = [ (lib.getAttrFromPath packagePath pkgs) ];
        }
        extraConfig
      ];
    };

  makeNixosProgramConfig =
    {
      config,
      programName,
      optionPath,
      extraConfig ? { },
    }:
    lib.my.makeSwitch {
      inherit config optionPath;
      optionName = programName;

      config' = lib.mkMerge [
        {
          programs = lib.setAttrByPath [ programName "enable" ] true;
        }
        extraConfig
      ];
    };
}
