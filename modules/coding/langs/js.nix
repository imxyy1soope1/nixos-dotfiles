{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "js";
  optionPath = [
    "coding"
    "langs"
    "js"
  ];
  config' = {
    my.home = {
      home.packages = with pkgs; [
        nodejs
        nodePackages.npm

        typescript
      ];
      home.file.".npmrc".text = ''
        prefix = ''${HOME}/.npm-global
        registry = https://registry.npmmirror.com
      '';
      programs.zsh.initContent = lib.mkAfter ''
        export PATH=$PATH:$HOME/.npm-global/bin
      '';
    };
    my.persist.homeDirs = [
      ".npm"
      ".npm-global"
    ];
  };
}
