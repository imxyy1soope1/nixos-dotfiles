{ config, secrets, ... }:
{
  sops.secrets.rsshub-env = {
    sopsFile = secrets.rsshub;
    restartUnits = [ "podman-rsshub.service" ];
    format = "dotenv";
  };
  services.rsshub = {
    enable = true;
    settings = {
      PORT = 8100;
      LISTEN_INADDR_ANY = false;
    };
    secretFiles = [ config.sops.secrets.rsshub-env.path ];
  };
  services.caddy.virtualHosts."rss.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8100
    '';
  };
  my.services.frp.webServers = [ "rss.imxyy.top" ];
}
