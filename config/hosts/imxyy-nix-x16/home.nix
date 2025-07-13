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
      sessionVariables = {
        PATH = "/home/${username}/bin:$PATH";
      };
    };
  };

  my = {
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
          "file://${homedir}/NAS NAS"
          "file://${homedir}/NAS/imxyy_soope_ NAS imxyy_soope_"
          "file://${homedir}/NAS/imxyy_soope_/OS NAS OS"
        ];
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
        ".local/share/cheat.sh"
        ".local/share/Kingsoft"

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
        ".config/pip"
        ".config/libreoffice"
        ".config/sunshine"
      ];
    };
  };
}
