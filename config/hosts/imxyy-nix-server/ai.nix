{ ... }:
{
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 8089;
  };
  services.caddy.virtualHosts."ai.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8089 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
