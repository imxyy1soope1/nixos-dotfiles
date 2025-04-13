{ config, sopsRoot, ... }:
{
  sops.secrets.vaultwarden-env = {
    sopsFile = sopsRoot + /vaultwarden.env;
    format = "dotenv";
  };
  services.postgresql.ensureUsers = [
    {
      name = "vaultwarden";
      ensureDBOwnership = true;
    }
  ];
  services.postgresql.ensureDatabases = [ "vaultwarden" ];
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8083;
      DOMAIN = "https://vault.imxyy.top";
    };
    environmentFile = "${config.sops.secrets.vaultwarden-env.path}";
  };
  services.caddy.virtualHosts."vault.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8083 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
