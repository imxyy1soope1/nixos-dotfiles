{ config, secrets, ... }:
let
  redisUrl = config.services.redis.servers.rsshub.unixSocket;
in
{
  sops.secrets.rsshub-env = {
    sopsFile = secrets.rsshub;
    format = "dotenv";
  };
  users.users.rsshub = {
    home = "/var/empty";
    group = "rsshub";
    isSystemUser = true;
  };
  users.groups.rsshub.members = [ "rsshub" ];
  services.redis.servers.rsshub = {
    enable = true;
    user = "rsshub";
  };
  virtualisation.oci-containers.containers.rsshub = {
    image = "diygod/rsshub";
    volumes = [
      "${redisUrl}:${redisUrl}"
    ];
    ports = [ "8100:1200" ];
    networks = [ "podman" ];
    environment = {
      CACHE_TYPE = "redis";
      REDIS_URL = "${redisUrl}";
    };
    environmentFiles = [ config.sops.secrets.rsshub-env.path ];
  };
  services.caddy.virtualHosts."rss.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8100
    '';
  };
  services.frp.settings.proxies = [
    {
      name = "rsshub-http";
      type = "http";
      localIP = "127.0.0.1";
      localPort = 80;
      customDomains = [ "rss.imxyy.top" ];
    }
    {
      name = "rsshub-https";
      type = "https";
      localIP = "127.0.0.1";
      localPort = 443;
      customDomains = [ "rss.imxyy.top" ];
    }
  ];
}
