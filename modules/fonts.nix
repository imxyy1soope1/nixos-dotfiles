{
  config,
  pkgs,
  lib,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default font settings";
  optionPath = [ "fonts" ];
  config' = {
    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;

      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji

        jetbrains-mono

        nerd-fonts.symbols-only
      ];

      fontconfig.defaultFonts = {
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif"
          "Symbols Nerd Font"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Sans"
          "Symbols Nerd Font"
        ];
        monospace = [
          "JetBrains Mono"
          "Noto Sans Mono CJK SC"
          "Symbols Nerd Font Mono"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
