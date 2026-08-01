{
  pkgs,
  username,
  ...
}:
{
  my.programs = {
    ollama.enable = true;

    localsend.enable = true;

    wpsoffice.enable = true;
    papers.enable = true;

    nautilus.enable = true;

    ayugram.enable = true;
    signal.enable = true;
    element.enable = true;
    fractal.enable = true;
    qq.enable = true;
    wechat.enable = true;
  };
  my.hm = {
    home.packages = with pkgs; [
      gnome-clocks
    ];
    programs.zsh = {
      sessionVariables = {
        PATH = "/home/${username}/bin:$PATH";
      };
    };
    programs.fish.interactiveShellInit = ''
      set -gp PATH $HOME/bin
    '';

    wayland.windowManager.niri.settings = {
      environment.STEAM_FORCE_DESKTOPUI_SCALING = "1.25";
      output = [
        {
          _args = [ "eDP-1" ];
          mode = "1920x1200@60.002";
          scale = 1.25;
        }
      ];
    };
  };

  my = {
    gpg.enable = true;
    cli.all.enable = true;
    coding.all.enable = true;
    desktop.all.enable = true;
    virt.moonlight.enable = true;
    i18n.fcitx5.enable = true;
    xdg.enable = true;

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
      ];
    };
  };
}
