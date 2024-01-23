{ pkgs, ... }: {
  home.packages = with pkgs; [
    # steam # defined in nixos/hosts/imxyy-nix.nix
    hmcl
    jre8
  ];
}
