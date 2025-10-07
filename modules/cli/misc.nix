{
  config,
  lib,
  pkgs,
  username,
  userfullname,
  useremail,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "misc command line tools";
  optionPath = [
    "cli"
    "misc"
  ];
  config' = {
    environment.systemPackages = with pkgs; [
      vim
      wget
      git

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

      comma
    ];

    programs.dconf.enable = true;

    my.hm = {
      home.packages = with pkgs; [
        lsd
        fd
        neofetch
        fastfetch
        fzf
        bat
        ripgrep

        aria2
        socat
      ];
      programs.tmux = {
        enable = true;
        extraConfig = "set-option -g mouse on";
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
