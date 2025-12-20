{
  pkgs,
  config,
  username,
  secrets,
  ...
}:
{
  boot.kernelParams = [
    "usbcore.autosuspend=-1" # Avoid usb autosuspend (for usb bluetooth adapter)
  ];

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
}
