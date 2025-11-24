rec {
  username = "imxyy";
  userfullname = "imxyy_soope_";
  userdesc = userfullname;
  emails = rec {
    gmail = "imxyy1soope1@gmail.com";
    selfhost = "imxyy@imxyy.top";
    default = gmail;
  };
  hosts = {
    "imxyy@imxyy-nix" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO";
    "imxyy-ace5" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8pivvE8PMtsOxmccfNhH/4KehDKhBfUfJbQZxo/SZT";
    "imxyy@imxyy-nix-x16" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMb5G/ieEYBOng66YeyttBQLThyM6W//z2POsNyq4Rw/";
    "imxyy_soope_@imxyy-cloudwin" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKALTBn/QSGcSPgMg0ViSazFcaA0+nEF05EJpjbsI6dE";
  };
}
