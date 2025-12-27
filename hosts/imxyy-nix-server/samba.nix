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
        browsable = "yes";
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
      isSystemUser = true;
      description = "NAS user";
      group = "nextcloud";
    };
  };
}
