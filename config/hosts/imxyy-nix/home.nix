{
  config,
  pkgs,
  username,
  ...
}:
{
  my.hm = {
    home.packages = with pkgs; [
      localsend

      wpsoffice-cn
      wps-office-fonts
      ttf-wps-fonts
      papers

      anki

      working.ayugram-desktop
      signal-desktop
      element-desktop
      fractal
      qq
      wechat

      gnome-clocks
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

    i18n.fcitx5.enable = true;

    xdg = {
      enable = true;
      defaultApplications =
        let
          browser = [ config.my.desktop.browser.default.desktop ];
          editor = [ "codium.desktop" ];
          imageviewer = [ "org.gnome.Shotwell-Viewer.desktop" ];
        in
        {
          "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

          "application/pdf" = [ "org.gnome.Papers.desktop" ];

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
    };
    persist = {
      enable = true;
      homeDirs = [
        ".android"
        "Android"

        "bin"
        "workspace"
        "Virt"

        ".cache"
        ".local/state"
        ".local/share/Anki2"
        ".local/share/shotwell"
        ".local/share/Kingsoft"

        ".local/share/AyuGramDesktop"
        ".local/share/fractal"
        ".config/Signal"
        ".config/Element"
        ".config/QQ"
        ".xwechat"

        ".config/Kingsoft"
        ".config/dconf"
        ".config/pip"
        ".config/sunshine"

        ".gemini"
        ".claude"
        ".claude-code-router"
      ];
    };
  };
}
