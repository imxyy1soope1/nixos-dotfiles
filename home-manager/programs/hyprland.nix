{
  config,
  pkgs,
  ...
}: {
  # home.packages = with pkgs; [
  #   hyprland
  # ];
  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;
  };
}
