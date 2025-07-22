{
  config,
  pkgs,
  sopsRoot,
  ...
}:
{
  sops.secrets.et-imxyy-nix-server-nixremote = {
    sopsFile = sopsRoot + /et-imxyy-nix-server-nixremote.toml;
    format = "binary";
  };
  environment.systemPackages = [ pkgs.easytier ];
  systemd.services."easytier-nixremote" = {
    enable = true;
    script = "${pkgs.easytier}/bin/easytier-core -c ${config.sops.secrets.et-imxyy-nix-server-nixremote.path}";
    serviceConfig = {
      Restart = "always";
      RestartSec = 30;
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "sops-nix.service"
    ];
  };
  users.groups.nixremote = { };
  users.users.nixremote = {
    isSystemUser = true;
    description = "nix remote build user";
    group = "nixremote";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBWOy0QmAyxENg/O5m3cus8U3c9jCLioivwcWsh5/a82 imxyy-hisense-pad"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8pivvE8PMtsOxmccfNhH/4KehDKhBfUfJbQZxo/SZT imxyy-ace5"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKALTBn/QSGcSPgMg0ViSazFcaA0+nEF05EJpjbsI6dE imxyy_soope_@imxyy-cloudwin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMb5G/ieEYBOng66YeyttBQLThyM6W//z2POsNyq4Rw/ imxyy@imxyy-nix-x16"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIENauvvhVMLsUwH9cPYsvnOg7VCL3a4yEiKm8I524TE efl@efl-nix"
    ];
  };
  nix.settings.trusted-users = [
    "nixremote"
  ];
}
