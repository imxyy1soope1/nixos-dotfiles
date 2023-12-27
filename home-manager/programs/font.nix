{ pkgs, ... }: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      twemoji

      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];

    fontconfig.defaultFonts = {
      serif = ["Noto Serif CJK SC" "Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans CJK SC" "Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
