{
  config,
  sopsRoot,
  ...
}:
{
  sops.secrets = {
    flatnote-env = {
      sopsFile = sopsRoot + /flatnote.env;
      format = "dotenv";
    };
    siyuan-env = {
      sopsFile = sopsRoot + /siyuan.env;
      format = "dotenv";
    };
  };
  virtualisation.oci-containers.containers = {
    flatnotes = {
      image = "dullage/flatnotes:latest";
      volumes = [
        "/mnt/nas/flatnotes/data:/data"
      ];
      environmentFiles = [
        "${config.sops.secrets.flatnote-env.path}"
      ];
      ports = [ "8093:8080" ];
    };
    siyuan = {
      image = "apkdv/siyuan-unlock:v3.1.30";
      volumes = [
        "/mnt/nas/siyuan/workspace:/workspace"
        "/mnt/nas/siyuan:/home/siyuan"
      ];
      cmd = [
        "--workspace=/workspace"
      ];
      environment = {
        PUID = "0";
        PGID = "0";
      };
      environmentFiles = [
        "${config.sops.secrets.siyuan-env.path}"
      ];
      ports = [ "8095:6806" ];
    };
    memos = {
      image = "neosmemo/memos:stable";
      volumes = [
        "/mnt/nas/memos:/var/opt/memos"
      ];
      ports = [ "8097:5230" ];
    };
  };
  services.caddy.virtualHosts = {
    "note.imxyy.top" = {
      extraConfig = ''
        reverse_proxy :8093
      '';
    };
    "sy.imxyy.top" = {
      extraConfig = ''
        reverse_proxy :8095
      '';
    };
    "memo.imxyy.top" = {
      extraConfig = ''
        reverse_proxy :8097
      '';
    };
  };
}
