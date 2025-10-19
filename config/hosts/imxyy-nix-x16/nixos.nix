{
  pkgs,
  config,
  username,
  secrets,
  ...
}:
{
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "524288";
    }
  ];

  boot.kernelParams = [
    "usbcore.autosuspend=-1" # Avoid usb autosuspend (for usb bluetooth adapter)
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    grub.enable = false;
    timeout = 0;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/cache/nix";
    serviceConfig.CacheDirectory = "nix";
  };
  environment.variables.NIX_REMOTE = "daemon";

  services.printing.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default.settings = {
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
  };

  services.gvfs.enable = true;

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
  };

  my.persist.nixosDirs = [ "/etc/NetworkManager/system-connections" ];
}
