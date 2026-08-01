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
      shellAliases = {
        cageterm = "cage -m DP-1 -s -- alacritty -o font.size=20";
        cagefoot = "cage -m DP-1 -s -- foot --font=monospace:size=20";
        cagekitty = "cage -m DP-1 -s -- kitty -o font_size=20";
      };
      sessionVariables = {
        no_proxy = "192.168.3.0/24";
        PATH = "/home/${username}/bin:$PATH";
      };
    };
    programs.fish = {
      shellAliases = {
        cageterm = "cage -m DP-1 -s -- alacritty -o font.size=20";
        cagefoot = "cage -m DP-1 -s -- foot --font=monospace:size=20";
        cagekitty = "cage -m DP-1 -s -- kitty -o font_size=20";
      };
      interactiveShellInit = ''
        set -g no_proxy "192.168.3.0/24"
        set -gp PATH $HOME/bin
      '';
    };

    wayland.windowManager.niri.settings = {
      environment.STEAM_FORCE_DESKTOPUI_SCALING = "1.25";
      output = [
        {
          _args = [ "DP-1" ];
          mode = "2560x1440@75.033";
          scale = 1.25;
          position._props = {
            x = 0;
            y = 0;
          };
        }
        {
          _args = [ "DP-2" ];
          mode = "2560x1440@75.033";
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
    i18n.fcitx5.enable = true;
    xdg.enable = true;

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

        ".config/sunshine"
      ];
    };
  };
}
