{
  services.caddy = {
    enable = true;
    email = "acme@imxyy.top";
    globalConfig = ''
      servers {
        listener_wrappers {
          proxy_protocol {
            timeout 5s
            allow 127.0.0.1/32
          }
          tls
        }
        trusted_proxies static 127.0.0.1
      }
    '';
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@imxyy.top";
  };
}
