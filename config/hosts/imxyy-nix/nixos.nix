{
  lib,
  pkgs,
  config,
  username,
  secrets,
  ...
}:
let
  btreset = pkgs.writeShellScriptBin "btreset" ''
    LOCKFILE="/tmp/.btreseted"
    SYM="BT"

    if [ -f "$LOCKFILE" ] && [ "$1" != "-f" ]; then
      exit 0
    fi

    ${lib.getExe' pkgs.usbutils "lsusb"} | grep "$SYM" | while read -r line; do
      bus=$(echo "$line" | awk '{print $2}')
      dev=$(echo "$line" | awk '{print $4}' | tr -d ':')
      ${lib.getExe' pkgs.usbutils "usbreset"} "$bus/$dev"

      touch "$LOCKFILE"
    done
  '';
in
{
  systemd.services.btreset = {
    script = lib.getExe btreset;
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
  };

  boot.kernelParams = [
    "usbcore.autosuspend=-1" # Avoid usb autosuspend (for usb bluetooth adapter)
    "fsck.mode=skip"
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      default.settings = {
        main = {
          capslock = "overload(control, esc)";
          home = "end";
        };
        shift = {
          home = "home";
        };
        control = {
          delete = "print";
        };
      };
      kone-pro-owl-eye = {
        ids = [ "1e7d:2dcd" ];
        settings.main.mouse2 = "rightmouse";
      };
    };
  };

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
  users.users.${username}.extraGroups = [ "wireshark" ];

  virtualisation.waydroid.enable = true;
  my.persist.homeDirs = [ ".local/share/waydroid" ];

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    applications.apps = [
      {
        name = "Desktop";
        image-path = "desktop.png";
      }
    ];
  };
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = null;
      PasswordAuthentication = true;
    };
  };

  environment.systemPackages = [
    pkgs.rclone
    btreset
  ];

  sops.secrets.imxyy-nix-rclone = {
    sopsFile = secrets.imxyy-nix-rclone;
    format = "binary";
  };
  fileSystems = {
    "/home/${username}/Nextcloud" = {
      device = "Nextcloud:";
      fsType = "rclone";
      options = [
        "nodev"
        "nofail"
        "allow_other"
        "args2env"
        "config=${config.sops.secrets.imxyy-nix-rclone.path}"
        "uid=1000"
        "gid=100"
        "rw"
        "no-check-certificate"
        "vfs-cache-mode=full"
      ];
    };
    "/home/${username}/NAS" = {
      device = "//192.168.3.2/share";
      fsType = "cifs";
      options = [
        "username=nas"
        "password=nasshare"
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
        "nodev"
        "nofail"
        "uid=1000"
        "gid=100"
        "vers=3"
        "rw"
      ];
    };
  };
}
