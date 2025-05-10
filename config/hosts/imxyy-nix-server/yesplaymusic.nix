_:
{
  virtualisation.oci-containers.containers."YesPlayMusic" = {
    image = "git.imxyy.top/imxyy1soope1/yesplaymusic:latest";
    environment = {
      "NODE_TLS_REJECT_UNAUTHORIZED" = "0";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
    ];
    ports = [
      "8088:80/tcp"
    ];
    log-driver = "journald";
  };

  services.caddy.virtualHosts."music.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8088 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
