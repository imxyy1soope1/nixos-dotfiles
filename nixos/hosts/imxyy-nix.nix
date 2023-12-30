{ pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  networking = {
    networkmanager.enable = true;
    bridges.br0.interfaces = [ "enp6s0" ];
    interfaces.enp6s0.useDHCP = false;
    interfaces.br0 = {
      macAddress = "3C:7C:3F:7C:D3:9D";
      useDHCP = true;
    };
    nameservers = [ "192.168.3.1" ];
  };

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif CJK SC" "Noto Serif" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans CJK SC" "Noto Sans" "Noto Color Emoji" ];
      monospace = [ "Noto Sans Mono SC" "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        capslock = "overload(control, esc)";
        home = "end";
      };
      shift = {
        home = "home";
      };
      control = {
        delete = "print";
      };
    };
  };
}
