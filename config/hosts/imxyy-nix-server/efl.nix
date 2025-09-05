{ config, secrets, ... }:
{
  sops.secrets.efl-tuwunel-env = {
    sopsFile = secrets.efl-tuwunel;
    format = "dotenv";
  };
  virtualisation.oci-containers.containers = {
    tuwunel = {
      image = "jevolk/tuwunel:latest";
      volumes = [
        "tuwunel_db:/var/lib/tuwunel"
      ];
      ports = [ "6167:6167" ];
      networks = [ "podman" ];
      environment = {
        TUWUNEL_SERVER_NAME = "mtx.eflx.top";
        TUWUNEL_PORT = "6167";
        TUWUNEL_ADDRESS = "0.0.0.0";
      };
      environmentFiles = [
        config.sops.secrets.efl-tuwunel-env.path
      ];
    };
    mautrix-telegram = {
      image = "dock.mau.dev/mautrix/telegram:latest";
      ports = [ "8099:8099" ];
      networks = [ "podman" ];
      extraOptions = [ "--ip=10.88.0.254" ];
      volumes = [ "/var/lib/efl-mautrix-telegram:/data" ];
    };

    send = {
      image = "lanol/filecodebox:latest";
      ports = [ "12345:12345" ];
      volumes = [ "/var/lib/send:/app/data:rw" ];
    };
  };
  services.caddy.virtualHosts."mtx.eflx.top" = {
    extraConfig = ''
      reverse_proxy :6167 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
  services.caddy.virtualHosts."send.eflx.top" = {
    extraConfig = ''
      reverse_proxy :12345 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
