{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  app = pkgs.buildNpmPackage (finalAttrs: {
    pname = "HF-plant";
    version = "unstable-2025-09-21";

    src = inputs.plant;

    buildPhase = ''
      runHook preBuild

      npm run build
      npm run build:proxy

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out
      cp .env proxy-server-bundled.js $out

      runHook postInstall
    '';

    npmDepsHash = "sha256-ret4BtjrEt8L1nlvJmFiejAKmbz89Z7NSiKs+qlB51w=";
  });
in
{
  systemd.services.HF-plant-proxy = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.bash} -c 'source ${app}/.env; export FEISHU_APP_ID FEISHU_APP_SECRET AMAP_JSCODE; ${lib.getExe pkgs.nodejs} ${app}/proxy-server-bundled.js'";
      Restart = "always";
      RestartSec = 120;
    };
  };
  services.caddy.virtualHosts."plant.imxyy.top" = {
    extraConfig = ''
      handle /api/* {
        reverse_proxy localhost:3001
      }

      handle /* {
        root * ${app}/dist
        try_files {path} /index.html
        file_server
      }
    '';
  };
  services.frp.settings.proxies = [
    {
      name = "plant-http";
      type = "http";
      localIP = "127.0.0.1";
      localPort = 80;
      customDomains = [ "plant.imxyy.top" ];
    }
    {
      name = "plant-https";
      type = "https";
      localIP = "127.0.0.1";
      localPort = 443;
      customDomains = [ "plant.imxyy.top" ];
    }
  ];
}
