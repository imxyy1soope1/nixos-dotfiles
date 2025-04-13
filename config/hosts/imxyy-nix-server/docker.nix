{ lib, ... }:
{
  virtualisation.oci-containers.backend = lib.mkForce "podman";
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
}
