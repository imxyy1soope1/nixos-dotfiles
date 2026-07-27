{ lib, ... }:
{
  virtualisation.oci-containers.backend = lib.mkForce "podman";
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.containers = {
    containersConf.settings.network = {
      # avoid collision with dnsmasq
      dns_bind_port = 5353;
      # keep netavark rules in an isolated `table inet netavark` instead of the
      # `table ip nat` that networking.nat recreates on each nixos-rebuild switch,
      # which would otherwise evict podman's published-port DNAT rules.
      firewall_driver = "nftables";
    };
  };
}
