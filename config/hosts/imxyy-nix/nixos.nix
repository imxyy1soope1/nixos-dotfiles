{
  lib,
  pkgs,
  config,
  username,
  secrets,
  ...
}:
let
  btreset = pkgs.writeScriptBin "btreset" ''
    #!${lib.getExe pkgs.python3}

    import subprocess
    import os
    import sys

    SYM = "BT"

    def action(line: str) -> bool:
        if line.find(SYM) == -1:
            return False
        temp = line.split(" ")
        bus = temp[1]
        device = temp[3][:-1]
        subprocess.run(["${lib.getExe' pkgs.usbutils "usbreset"}", f"{bus}/{device}"])
        return True

    if __name__ == "__main__":
        if os.path.exists("/tmp/.btreseted") and len(sys.argv) == 1 and "-f" not in sys.argv[1:]:
            exit(0)
        res_byte = subprocess.check_output("/run/current-system/sw/bin/lsusb")
        res = res_byte.decode()
        lst = res.split("\n")

        if any(tuple(map(action, lst))):
            with open("/tmp/.btreseted", "w"):
                ...
  '';
in
{
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "524288";
    }
  ];

  systemd.services.btreset = {
    script = lib.getExe btreset;
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
  };
  boot.kernelParams = [
    "usbcore.autosuspend=-1" # Avoid usb autosuspend (for usb bluetooth adapter)
    "fsck.mode=skip"
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

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      jetbrains-mono

      nerd-fonts.symbols-only
    ];

    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif CJK SC"
        "Noto Serif"
        "Symbols Nerd Font"
      ];
      sansSerif = [
        "Noto Sans CJK SC"
        "Noto Sans"
        "Symbols Nerd Font"
      ];
      monospace = [
        "JetBrains Mono"
        "Noto Sans Mono CJK SC"
        "Symbols Nerd Font Mono"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  services.printing.enable = true;

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

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
  users.users.${username}.extraGroups = [ "wireshark" ];

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
