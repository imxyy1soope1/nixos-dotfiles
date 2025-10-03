{
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

      ayugram-desktop
      signal-desktop
      element-desktop
      fractal
      qq
      wechat

      gnome-clocks
    ];
    programs.zsh = {
      sessionVariables = {
        PATH = "/home/${username}/bin:$PATH";
      };
    };

    programs.niri.settings = {
      environment.STEAM_FORCE_DESKTOPUI_SCALING = "1.25";
      outputs = {
        eDP-1 = {
          enable = true;
          mode = {
            width = 1920;
            height = 1200;
            refresh = 60.002;
          };
          scale = 1.25;
        };
      };
    };
  };

  my = {
    gpg.enable = true;
    cli.all.enable = true;
    coding.all.enable = true;
    desktop.all.enable = true;
    virt.moonlight.enable = true;

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
        "Documents"
        "Downloads"
        "Videos"
        "Music"
        "Pictures"

        "bin"
        "workspace"

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
      homeFiles = [
        ".claude.json"
      ];
    };
  };
}
