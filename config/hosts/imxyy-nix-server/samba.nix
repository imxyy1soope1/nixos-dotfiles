{ ... }:
{
  services.samba = {
    enable = true;
    nsswins = true;
    settings = {
      global = {
        security = "user";
        "netbios name" = "NAS";
      };
      share = {
        path = "/mnt/nas/share";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "nextcloud";
        "force group" = "nextcloud";
      };
    };
  };
  services.samba-wsdd.enable = true;
  # ensure dir exists
  systemd.tmpfiles.rules = [
    "d /mnt/nas/share 0775 nextcloud nextcloud - -"
  ];
  users = {
    users.nas = {
      isNormalUser = true;
      home = "/var/empty";
      description = "nas user";
      group = "nextcloud";
    };
  };
}
