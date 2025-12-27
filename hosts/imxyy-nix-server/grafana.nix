{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 8090;
        domain = "grafana.imxyy.top";
      };
    };
  };
  services.prometheus = {
    enable = true;
    port = 8091;
    exporters = {
      node = {
        enable = true;
        port = 8092;
        enabledCollectors = [
          "systemd"
          "zfs"
        ];
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "127.0.0.1:8092" ];
          }
        ];
      }
    ];
  };
  services.caddy.virtualHosts."grafana.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8090 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
