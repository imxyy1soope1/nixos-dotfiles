{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.fonts;
in
{
  options.my.fonts = {
    enable = lib.mkEnableOption "default font settings" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;

      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji

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
