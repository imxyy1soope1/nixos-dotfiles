{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "Typst";
  optionPath = [
    "coding"
    "langs"
    "typst"
  ];
  config' = {
    my.hm.home.packages = with pkgs; [
      typst
      tinymist
    ];
  };
}
