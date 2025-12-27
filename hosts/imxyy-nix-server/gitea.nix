{
  services.caddy.virtualHosts."git.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8082 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
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
        REGISTER_MANUAL_CONFIRM = true;
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
