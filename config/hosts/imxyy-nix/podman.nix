{
  lib,
  pkgs,
  username,
  ...
}:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
  users.users.${username}.extraGroups = [ "podman" ];
  environment.systemPackages = [ pkgs.distrobox ];
  my.hm.programs.distrobox = {
    enable = true;
    settings = {
      container_image_default = "docker.io/archlinux:latest";
    };
    containers = {
      archlinux = {
        image = "archlinux:latest";
      };
    };
  };
  my.hm.programs.zsh.initContent = lib.mkBefore ''
    if [ -n "''${CONTAINER_ID+1}" ]; then
      export ZSH_DISABLE_COMPFIX=true
    fi
  '';
  my.persist.homeDirs = [
    ".config/containers"
    ".local/share/containers"
  ];
}
