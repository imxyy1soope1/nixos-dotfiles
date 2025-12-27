{ config, secrets, ... }:
{
  sops.secrets.sshwifty = {
    sopsFile = secrets.sshwifty;
    format = "binary";
  };
  services.sshwifty = {
    enable = true;
    sharedKeyFile = config.sops.secrets.sshwifty.path;
    settings = {
      Servers = [
        {
          ListenInterface = "0.0.0.0";
          ListenPort = 8101;
          InitialTimeout = 10;
          ReadTimeout = 120;
          WriteTimeout = 120;
          HeartbeatTimeout = 10;
          ReadDelay = 10;
          WriteDelay = 10;
          TLSCertificateFile = "";
          TLSCertificateKeyFile = "";
          ServerMessage = "";
        }
      ];
    };
  };
  services.caddy.virtualHosts."ssh.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8101
    '';
  };
  services.frp.instances."".settings.proxies = [
    {
      name = "sshwifty-http";
      type = "http";
      localIP = "127.0.0.1";
      localPort = 80;
      customDomains = [ "ssh.imxyy.top" ];
    }
    {
      name = "sshwifty-https";
      type = "https";
      localIP = "127.0.0.1";
      localPort = 443;
      customDomains = [ "ssh.imxyy.top" ];
    }
  ];
}
