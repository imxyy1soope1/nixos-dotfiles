{ config
, pkgs
, ...
}: {
  # Alacritty
  programs.alacritty.enable = true;
  xdg.configFile."alacritty" = {
    source = ./alacritty;
    recursive = true;
  };

  # Kitty
  programs.kitty.enable = true;
  xdg.configFile."kitty" = {
    source = ./kitty;
    recursive = true;
  };
}
