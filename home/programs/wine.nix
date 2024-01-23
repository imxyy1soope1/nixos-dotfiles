{ pkgs, ... }: {
  home.packages = with pkgs; [
    wineWowPackages.staging
  ];
}
