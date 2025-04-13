{ lib, hostname, ... }:
{
  environment.etc.issue.text = "\\e{lightcyan}\\S\\e{reset} Login (\\l)\n\n";
  networking.hostName = hostname;
  system.stateVersion = "24.11";
  systemd.services."systemd-machine-id-commit".enable = lib.mkForce false;

  my = {
    home = {
      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";
      home.stateVersion = "24.11";
    };

    xdg.enable = true;
    persist = {
      nixosDirs = [
        "/root"
        "/var"
      ];
      nixosFiles = [
        "/etc/machine-id"
      ];
    };
  };
}
