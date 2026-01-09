{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.cli.misc;
in
{
  options.my.cli.misc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable misc command line tools";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
      wget

      file
      gnused
      gnutar

      zip
      unzip
      xz
      p7zip
      unrar-free

      pciutils
      usbutils

      lsof

      nmap
      traceroute
      tcping-go
      dnsutils

      killall
    ];

    programs.dconf.enable = true;

    my.persist.homeDirs = [
      ".local/share/zoxide"
      ".config/television/cable"
    ];
    my.hm = {
      home.packages = with pkgs; [
        # keep-sorted start
        aria2
        bat
        comma
        fastfetch
        fd
        fzf
        keep-sorted
        lsd
        neofetch
        ripgrep
        socat
        typos
        # keep-sorted end
      ];
      programs.tmux = {
        enable = true;
        extraConfig = ''
          set-option -g mouse on
          set-option -a terminal-features ",xterm-256color:RGB,focus,clipboard,usstyle"
        '';
        plugins = [
          (pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "tokyo-night-tmux";
            rtpFilePath = "tokyo-night.tmux";
            version = "legacy";
            src = pkgs.fetchFromGitHub {
              owner = "janoamaral";
              repo = "tokyo-night-tmux";
              rev = "16469dfad86846138f594ceec780db27039c06cd";
              hash = "sha256-EKCgYan0WayXnkSb2fDJxookdBLW0XBKi2hf/YISwJE=";
            };
          })
        ];
      };
      programs.tealdeer = {
        enable = true;
        enableAutoUpdates = true;
        settings.updates.auto_update = true;
      };
      programs.television = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
      xdg.configFile."fastfetch/config.jsonc".text = ''
        {
          "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
          "display": {
            "separator": "  "
          },
          "modules": [
            // Title
            {
              "type": "title",
              "format": "{user-name-colored}{#}@{host-name-colored}"
            },
            {
              "type": "custom",
              "format": "---------------"
            },
            // System Information
            {
              "type": "custom",
              "format": "{#}System Information"
            },
            {
              "type": "os",
              "key": "{#keys}󰍹 OS"
            },
            {
              "type": "kernel",
              "key": "{#keys}󰒋 Kernel"
            },
            {
              "type": "uptime",
              "key": "{#keys}󰅐 Uptime"
            },
            {
              "type": "packages",
              "key": "{#keys}󰏖 Packages",
              "format": "{all}"
            },
            {
              "type": "custom",
              "format": ""
            },
            // Desktop Environment
            {
              "type": "custom",
              "format": "{#}Desktop Environment"
            },
            {
              "type": "de",
              "key": "{#keys}󰧨 DE"
            },
            {
              "type": "wm",
              "key": "{#keys}󱂬 WM"
            },
            {
              "type": "wmtheme",
              "key": "{#keys}󰉼 Theme"
            },
            {
              "type": "display",
              "key": "{#keys}󰹑 Resolution"
            },
            {
              "type": "shell",
              "key": "{#keys}󰞷 Shell"
            },
            {
              "type": "terminalfont",
              "key": "{#keys}󰛖 Font"
            },
            {
              "type": "custom",
              "format": ""
            },
            // Hardware Information
            {
              "type": "custom",
              "format": "{#}Hardware Information"
            },
            {
              "type": "cpu",
              "key": "{#keys}󰻠 CPU"
            },
            {
              "type": "gpu",
              "key": "{#keys}󰢮 GPU"
            },
            {
              "type": "memory",
              "key": "{#keys}󰍛 Memory"
            },
            {
              "type": "disk",
              "key": "{#keys}󰋊 Disk (/)",
              "folders": "/"
            },
            {
              "type": "custom",
              "format": ""
            },
            // Colors
            {
              "type": "colors",
              "symbol": "circle"
            },
          ]
        }
      '';
    };
  };
}
