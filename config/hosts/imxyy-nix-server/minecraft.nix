{ lib, pkgs, ... }:
{
  systemd.services."fabric1.20.6" = {
    description = "fabric 1.20.6 minecraft server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      WorkingDirectory = "/opt/minecraft/fabric1.20.6";
      ExecStart = "${lib.getExe' pkgs.openjdk21 "java"} -Xms1G -Xmx5G -jar fabric-server-mc.1.20.6-loader.0.15.11-launcher.1.0.1.jar";
      Restart = "always";
      RestartSec = 120;
    };
  };
  my.persist = {
    nixosDirs = [
      "/opt/minecraft"
    ];
  };
}
