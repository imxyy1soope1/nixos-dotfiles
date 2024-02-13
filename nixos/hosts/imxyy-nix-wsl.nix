{ pkgs
, username
, nixos-wsl
, ...
}: {
  imports = [
    nixos-wsl.nixosModules.wsl
  ];
  wsl.enable = true;
  wsl.defaultUser = "${username}";

  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      jetbrains-mono

      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
        ];
      })
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif CJK SC" "Noto Serif" "Symbols Nerd Font" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans CJK SC" "Noto Sans" "Symbols Nerd Font" "Noto Color Emoji" ];
      monospace = [ "JetBrains Mono" "Noto Sans Mono CJK SC" "Symbols Nerd Font Mono" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
