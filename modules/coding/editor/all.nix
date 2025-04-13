{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  optionName = "all coding editors";
  optionPath = [
    "coding"
    "editor"
    "all"
  ];
  config' = {
    my.coding.editor = {
      neovim.enable = true;
      vscode.enable = true;
    };
  };
}
