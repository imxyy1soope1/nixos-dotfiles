{ config, lib, ... }:
let
  cfg = config.my.services.frp;
  mkServer = domain: [
    {
      name = "${domain}-http";
      type = "http";
      localIP = "127.0.0.1";
      localPort = 80;
      customDomains = [ domain ];
    }
    {
      name = "${domain}-https";
      type = "https";
      localIP = "127.0.0.1";
      localPort = 443;
      customDomains = [ domain ];
      transport.proxyProtocolVersion = "v2";
    }
  ];
in
{
  options = {
    my.services.frp.webServers = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
  };

  config = {
    services.frp.instances."".settings.proxies = builtins.concatLists (map mkServer cfg.webServers);
  };
}
