{ pkgs, username, ... }: {
  imports = [
    ../impermanence/imxyy-nix.nix
  ];

  boot.kernelParams = [
    /*"drm.edid_firmware=edid/edid.bin"*/
    "usbcore.autosuspend=-1" # Avoid usb autosuspend (for usb bluetooth adapter)
    "fsck.mode=skip"
  ];
  /* hardware.firmware = [
    (pkgs.runCommand "edid.bin" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${./edid.bin} $out/lib/firmware/edid/edid.bin
    '')
  ]; */

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  networking = {
    interfaces.enp6s0 = {
      macAddress = "3C:7C:3F:7C:D3:9D";
      ipv4.addresses = [
        {
          address = "192.168.3.253";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2409:8a55:a74:bd41:3e7c:3fff:fe7c:d39d";
          prefixLength = 64;
        }
        {
          address = "2409:8a55:a74:bd41:f487:c51d:2b10:ae";
          prefixLength = 128;
        }
        {
          address = "2409:8a55:a74:bd41:6a5f:6a2f:4527:2efa";
          prefixLength = 64;
        }
        {
          address = "fe80::3e7c:3fff:fe7c:d39d";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway = "192.168.3.1";
    nameservers = [ "192.168.3.1" "114.114.114.114" ];
  };

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/cache/nix";
    serviceConfig.CacheDirectory = "nix";
  };
  environment.sessionVariables.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  environment.variables.NIX_REMOTE = "daemon";

  # mum's password
  # users.users.${username}.hashedPassword = "$y$j9T$PnRLh2qEHscwT9zVxSvJF1$SV/38KixGslAAz50w3FTMWnMyvjBVTIXtyUMVYWi4D3";

  # my password
  users.users.${username}.hashedPassword = "$y$j9T$kQetzbkIxGM89AgL4uljd/$8TJloT5NGyJHoRgAVjK4r094QcaT8Mf2Q9bVm4LLRQ9";
  users.users.root.hashedPassword = "$y$j9T$kQetzbkIxGM89AgL4uljd/$8TJloT5NGyJHoRgAVjK4r094QcaT8Mf2Q9bVm4LLRQ9";

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
      unload-module module-suspend-on-idle
    '';
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  users.extraUsers.${username}.extraGroups = [ "audio" ];

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

  environment.sessionVariables = {
    GTK_IM_MODULE = "";
    QT_IM_MODULE = "fcitx";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-chinese-addons fluent-fcitx5 fcitx5-lightly ];
      waylandFrontend = true;
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
            # Theme = "FluentLight";
            PerScreenDPI = true;
            EnableFractionalScale = true;
          };
          punctuation.globalSection = {
            HalfWidthPuncAfterLetterOrNumber = true;
            TypePairedPunctuationsTogether = false;
            Enabled = true;
          };
          pinyin = {
            globalSection = {
              PageSize = 9;
              EmojiEnabled = false;
              ChaiziEnabled = true;
              ExtBEnabled = true;
              CloudPinyinEnabled = true;
              CloudPinyinIndex = 2;
              PreeditInApplication = true;
            };
            sections = {
              Fuzzy = {
                VE_UE = true;
                NG_GN = true;
                Inner = true;
                InnerShort = true;
                PartialFianl = false;
                V_U = true;
                IN_ING = true;
                U_OU = true;
              };
            };
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
      ignoreUserConfig = true;
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
  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };
}
