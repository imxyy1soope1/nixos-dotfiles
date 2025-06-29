{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  my.home = {
    home.packages = with pkgs; [
      localsend

      rclone

      wpsoffice-cn
      wps-office-fonts
      ttf-wps-fonts
      evince

      anki

      ayugram-desktop
      telegram-desktop
      signal-desktop
      discord
      qq
      wechat

      gnome-clocks

      wineWowPackages.waylandFull

      pavucontrol
      pamixer
    ];
    programs.zsh = {
      shellAliases = {
        cageterm = "cage -m DP-2 -s -- alacritty -o font.size=20";
        cagefoot = "cage -m DP-2 -s -- foot --font=monospace:size=20";
        cagekitty = "cage -m DP-2 -s -- kitty -o font_size=20";
      };
      sessionVariables = {
        no_proxy = "192.168.3.0/24";
        PATH = "/home/${username}/bin:$PATH";
      };
      profileExtra = ''
        if [ `tty` = "/dev/tty6" ]; then
          clear
        fi
      '';
    };

    programs.niri.settings = {
      environment.STEAM_FORCE_DESKTOPUI_SCALING = "1.25";
      outputs = {
        DP-2 = {
          enable = true;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 75.033;
          };
          scale = 1.25;
          position = {
            x = 0;
            y = 0;
          };
        };
        DP-3 = {
          enable = true;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 75.033;
          };
          scale = 1.25;
        };
      };
    };
  };

  my = {
    autologin = {
      enable = true;
      user = username;
      ttys = [ 6 ];
    };

    gpg.enable = true;
    cli.all.enable = true;
    coding.all.enable = true;
    desktop.all.enable = true;

    desktop.browser.librewolf.enable = lib.mkForce false;

    i18n.fcitx5.enable = true;

    xdg = {
      enable = true;
      defaultApplications =
        let
          browser = [ "zen-beta.desktop" ];
          editor = [ "codium.desktop" ];
          imageviewer = [ "org.gnome.Shotwell-Viewer.desktop" ];
        in
        {
          "inode/directory" = [ "nemo.desktop" ];

          "application/pdf" = [ "org.gnome.Evince.desktop" ];

          "text/*" = editor;
          "application/json" = editor;
          "text/html" = editor;
          "text/xml" = editor;
          "application/xml" = editor;
          "application/xhtml+xml" = editor;
          "application/xhtml_xml" = editor;
          "application/rdf+xml" = editor;
          "application/rss+xml" = editor;
          "application/x-extension-htm" = editor;
          "application/x-extension-html" = editor;
          "application/x-extension-shtml" = editor;
          "application/x-extension-xht" = editor;
          "application/x-extension-xhtml" = editor;

          "x-scheme-handler/about" = browser;
          "x-scheme-handler/ftp" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/unknown" = browser;

          "audio/*" = imageviewer;
          "video/*" = imageviewer;
          "image/*" = imageviewer;
          "image/gif" = imageviewer;
          "image/jpeg" = imageviewer;
          "image/png" = imageviewer;
          "image/webp" = imageviewer;
        };
      extraBookmarks =
        let
          homedir = config.my.home.home.homeDirectory;
        in
        [
          "file://${homedir}/Documents/%E7%8F%AD%E7%BA%A7%E4%BA%8B%E5%8A%A1 班级事务"
          "file://${homedir}/NAS NAS"
          "file://${homedir}/NAS/imxyy_soope_ NAS imxyy_soope_"
          "file://${homedir}/NAS/imxyy_soope_/OS NAS OS"
        ];
    };
    persist = {
      enable = true;
      homeDirs = [
        ".android"
        "Android"

        ".ssh"

        "bin"
        "workspace"
        "Virt"

        ".cache"
        ".local/state"
        ".local/share/Anki2"
        ".local/share/dooit"
        ".local/share/nvim"
        ".local/share/shotwell"
        ".local/share/Steam"
        ".local/share/SteamOS"
        ".local/share/Trash"
        ".local/share/cheat.sh"
        ".local/share/Kingsoft"
        ".local/share/oss.krtirtho.spotube"

        ".local/share/AyuGramDesktop"
        ".local/share/TelegramDesktop"
        ".config/Signal"
        ".config/discord"
        ".config/QQ"
        ".xwechat"

        ".config/Kingsoft"
        ".config/dconf"
        ".config/gh"
        ".config/pulse"
        ".config/go-musicfox/db"
        ".config/pip"
        ".config/obs-studio"
        ".config/libreoffice"
        ".config/Moonlight Game Streaming Project"
        ".config/sunshine"
      ];
      nixosDirs = [
        "/etc/ssh"
      ];
      homeFiles = [
        ".config/mpd/mpd.db" # requires bindfs
        ".config/go-musicfox/cookie"
        ".hmcl.json"
      ];
    };
  };
}
