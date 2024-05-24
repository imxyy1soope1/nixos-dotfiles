{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    xdg-utils # `xdg-mime` `xdg-open` and so on
  ];

  xdg =
    let
      homedir = config.home.homeDirectory;
      browser = [ "firefox.desktop" ];
      editor = [ "neovim.desktop" ];
      imageviewer = [ "org.gnome.Shotwell-Viewer.desktop" ];
    in
    {
      enable = true;

      cacheHome = "${homedir}/.cache";
      configHome = "${homedir}/.config";
      dataHome = "${homedir}/.local/share";
      stateHome = "${homedir}/.local/state";

      userDirs.enable = true;

      configFile."mimeapps.list".force = true;

      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = [ "nemo.desktop" ];

          "application/pdf" = [ "evince.desktop" ];

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
    };

}
