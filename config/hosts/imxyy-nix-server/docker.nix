{ lib, ... }:
{
  virtualisation.oci-containers.backend = lib.mkForce "podman";
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  # avoid collision with dnsmasq
  virtualisation.containers = {
    containersConf.settings.network.dns_bind_port = 5353;
  };
}
