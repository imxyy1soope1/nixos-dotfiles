{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeHomePackageConfig {
  inherit config pkgs;
  packageName = "python3";
  packagePath = [ "python3" ];
  optionPath = [
    "coding"
    "langs"
    "python"
  ];
  extraConfig = {
    my.hm.home.packages = with pkgs; [
      uv
      pyright
    ];
  };
}
