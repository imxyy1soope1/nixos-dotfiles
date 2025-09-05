{ config, secrets, ... }:
{
  sops.secrets.minio-env = {
    sopsFile = secrets.minio;
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
}
