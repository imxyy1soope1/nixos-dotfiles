{ ... }:
{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 8096;
    mediaLocation = "/mnt/nas/immich";
    group = "nextcloud";
  };
  services.caddy.virtualHosts."immich.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8096 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
