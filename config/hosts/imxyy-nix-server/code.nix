{ config, ... }:
{
  services.postgresql.ensureUsers = [
    {
      name = "coder";
      ensureDBOwnership = true;
    }
  ];
  services.postgresql.ensureDatabases = [ "coder" ];
  virtualisation.oci-containers = {
    containers = {
      coder = {
        image = "ghcr.io/coder/coder:latest";
        environment = {
          CODER_ACCESS_URL = "https://coder.imxyy.top";
          CODER_HTTP_ADDRESS = "0.0.0.0:8086";
          CODER_PG_CONNECTION_URL = "postgresql://coder:coderdatabase@127.0.0.1/coder?sslmode=disable";
        };
        extraOptions = [
          "--network=host"
          "--group-add=${toString config.users.groups.podman.gid}"
        ];
        volumes = [
          "/var/lib/coder:/home/coder/.config"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        ports = [ "8086:8086" ];
      };
    };
  };
  services.caddy.virtualHosts."coder.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8086 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
