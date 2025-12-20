{
  config,
  hostname,
  ...
}:
{
  # I prefer this to the default issue text
  # ported from ArchLinux IIRC
  environment.etc.issue.text = "\\e{lightcyan}\\S\\e{reset} Login (\\l)\n\n";
  networking.hostName = hostname;
  # don't change this unless you know what you are doing!
  # for further information, see wiki.nixos.org
  system.stateVersion = "24.11";
  # disable this since we already have machine-id persisted
  systemd.services."systemd-machine-id-commit".enable = !config.my.persist.enable;

  # Enable core modules (user, nix, xdg, time are enabled by default)
  my = {
    user.enable = true;
    nix.enable = true;
    xdg.enable = true;
    time.enable = true;
  };

  # Base persistence configuration
  my.persist = {
    nixosDirs = [
      "/root"
      "/var"
      "/etc/ssh"
    ];
    nixosFiles = [
      "/etc/machine-id"
    ];
    homeDirs = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };

  # Home Manager base configuration
  my.hm = {
    # nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "24.11";
  };
}
