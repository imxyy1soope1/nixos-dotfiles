{
  config,
  lib,
  pkgs,
  username,
  userfullname,
  useremail,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "jujutsu";
  optionPath = [
    "cli"
    "vcs"
    "jj"
  ];
  extraConfig = {
    my.home = {
      programs.jujutsu = {
        settings = {
          user = {
            name = "${userfullname}";
            email = "${useremail}";
          };
          ui = {
            graph.style = "square";
            default-command = "status";
            conflict-marker-style = "snapshot";
          };
          signing = {
            backend = "ssh";
            behavior = "own";
            key = "/home/${username}/.ssh/id_ed25519";
            backends.backends.ssh.allowed-signers =
              (pkgs.writeText "allowed_signers" ''
                imxyy1soope1@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
                imxyy@imxyy.top ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
              '').outPath;
          };
        };
      };
      home.packages = [ pkgs.lazyjj ];
    };
  };
}
