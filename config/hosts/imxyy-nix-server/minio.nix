{ config, sopsRoot, ... }:
{
  sops.secrets.minio-env = {
    sopsFile = sopsRoot + /minio.env;
    format = "dotenv";
  };
  services.minio = {
    enable = true;
    listenAddress = ":9000";
    consoleAddress = ":9001";
    region = "cn-south-gz";

    configDir = "/mnt/nas/minio/config";
    dataDir = [
      "/mnt/nas/minio/data"
    ];
    rootCredentialsFile = config.sops.secrets.minio-env.path;
  };
  services.caddy.virtualHosts."minio.imxyy.top" = {
    extraConfig = ''
      handle_path /* {
          reverse_proxy :9000
      }
    '';
  };
}
