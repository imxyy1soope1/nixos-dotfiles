{ pkgs, ... }: {
  home.packages = with pkgs; [
    wine64
  ];
}
