{
  services.caddy.virtualHosts."git.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8082
    '';
  };
  my.services.frp.webServers = [ "git.imxyy.top" ];
  services.frp.instances."".settings.proxies = [
    {
      name = "gitea-ssh";
      type = "tcp";
      localIP = "127.0.0.1";
      localPort = 2222;
      remotePort = 2222;
    }
  ];
  services.gitea = {
    enable = true;
    appName = "imxyy_soope_'s Gitea";
    user = "git";
    group = "git";
    mailerPasswordFile = "/var/lib/gitea/smtp_password";
    stateDir = "/mnt/nas/gitea";
    settings = {
      globalSection = {
        LANDING_PAGE = "explore";
      };
      server = {
        DOMAIN = "git.imxyy.top";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 8082;
        ROOT_URL = "https://git.imxyy.top/";
        SSH_PORT = 2222;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      security = {
        REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.0/8,::1/128";
      };
    };
  };
  services.openssh.ports = [
    22
    2222
  ];
  users = {
    users.git = {
      isNormalUser = true;
      description = "git user";
      group = "git";
      home = "/mnt/nas/gitea";
    };
    groups.git = { };
  };
}
