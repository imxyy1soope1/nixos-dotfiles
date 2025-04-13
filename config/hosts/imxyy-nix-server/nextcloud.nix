{
  lib,
  pkgs,
  hostname,
  ...
}:
let
  nextcloud = "nextcloud.${imxyy}";
  imxyy = "imxyy.top";
in
{
  environment.systemPackages = with pkgs; [
    exiftool
    ffmpeg
    rclone
  ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    extraApps = {
      inherit (pkgs.nextcloud31.packages.apps)
        bookmarks
        previewgenerator
        spreed
        notes
        registration
        ;
    };
    extraAppsEnable = true;
    hostName = nextcloud;
    home = "/mnt/nas/nextcloud";
    https = true;
    nginx.recommendedHttpHeaders = true;
    caching.redis = true;
    configureRedis = true;
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = toString (pkgs.writeText "nextcloud-pass" "admin12345!");
      adminuser = "admin";
    };
    settings.trusted_domains = [
      hostname
      "192.168.3.2"
      "10.0.0.1"
    ];
    phpExtraExtensions =
      all: with all; [
        pdlib
      ];
    maxUploadSize = "16G";
    phpOptions = {
      "opcache.enable" = 1;
      "opcache.enable_cli" = 1;
      "opcache.interned_strings_buffer" = 8;
      "opcache.max_accelerated_files" = 10000;
      "opcache.memory_consumption" = 128;
      "opcache.save_comments" = 1;
      "opcache.revalidate_freq" = 1;
      memory_limit = lib.mkForce "2G";
    };
    poolSettings = {
      pm = "dynamic";
      "pm.max_children" = "12";
      "pm.min_spare_servers" = "6";
      "pm.max_spare_servers" = "12";
    };
  };
  services.nginx.virtualHosts."nextcloud.imxyy.top" = {
    listen = [
      {
        addr = "0.0.0.0";
        port = 8084;
      }
    ];
  };
  /*
    services.caddy.virtualHosts.":80" = {
      extraConfig = ''
        redir https://{host}{uri}
      '';
    };
    services.caddy.virtualHosts.":443" = {
      extraConfig =
        let
          path = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/nextcloud.imxyy.top";
        in
        ''
          reverse_proxy :8084
          tls ${path}/nextcloud.imxyy.top.crt ${path}/nextcloud.imxyy.top.key
        '';
    };
  */
  services.caddy.virtualHosts."nextcloud.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8084 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };

  /*
    systemd.timers."kopia" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "kopia.service";
      };
    };
  */

  systemd.services."kopia" = {
    script = ''
      ${pkgs.kopia}/bin/kopia snapshot create /mnt/nas/share
      ${pkgs.kopia}/bin/kopia snapshot create /mnt/nas/nextcloud/data
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
  };

  systemd.timers."nextcloud-cronjobs" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "nextcloud-cronjobs.service";
    };
  };

  systemd.services."nextcloud-cronjobs" = {
    script = ''
      /run/current-system/sw/bin/nextcloud-occ preview:pre-generate
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
  };
}
