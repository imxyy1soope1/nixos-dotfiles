{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "lua";
  optionPath = [
    "coding"
    "langs"
    "lua"
  ];
  config' = {
    my.hm.home.packages = with pkgs; [
      luajit
      stylua
      lua-language-server
    ];
  };
}
