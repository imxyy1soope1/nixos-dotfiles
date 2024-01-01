{ pkgs, username, ... }: {
  boot.kernelParams = [ "usbcore.autosuspend=-1" ]; # Avoid usb autosuspend (for usb bluetooth adapter)

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
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

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  hardware.bluetooth.enable = true;
  users.extraUsers.${username}.extraGroups = [ "audio" ];
  environment.systemPackages = with pkgs; [
    pamixer
  ];

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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-chinese-addons ];
      settings = {
        globalOptions = {
          "Hotkey"."EnumrateWithTriggerKeys" = true;
          "Hotkey/AltTriggerKeys"."0" = "Shift_L";
          "Hotkey/EnumerateForwardKeys"."0" = "Super+space";
          "Hotkey/EnumerateBackwardKeys"."0" = "Shift+Super+space";
        };
        inputMethod = {
          "Groups/0" = {
            "Name" = "Default";
            "Default Layout" = "us";
            "DefaultIM" = "pinyin";
          };
          "Groups/0/Items/0" = {
            "Name" = "keyboard-us";
            "Layout" = "";
          };
          "Groups/0/Items/1" = {
            "Name" = "pinyin";
            "Layout" = "";
          };
          "GroupOrder"."0" = "Default";
        };
        addons = {
          classicui.globalSection = {
            WheelForPaging = true;
            Font = "sans-serif 10";
            MenuFont = "Noto Sans CJK SC 10";
            TrayFont = "Noto Sans CJK SC Bold 10";
            Theme = "lightly";
            PerScreenDPI = true;
            EnableFractionalScale = true;
          };
          punctuation.globalSection = {
            HalfWidthPuncAfterLetterOrNumber = true;
            TypePairedPunctuationsTogether = false;
            Enabled = true;
          };
          cloudpinyin.globalSection = {
            Backend = "Baidu";
            MinimumPinyinLength = 4;
          };
          clipboard.globalSection = {
            TriggerKey = "";
          };
        };
      };
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

  services.v2raya.enable = true;

  services.getty.autologin = {
    enable = true;
    user = "${username}";
    ttys = [ "6" ];
  };


  # Steam
  programs.steam.enable = true;
}
