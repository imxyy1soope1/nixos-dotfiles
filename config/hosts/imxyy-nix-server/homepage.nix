{
  virtualisation.oci-containers = {
    containers = {
      sun-panel = {
        image = "hslr/sun-panel:latest";
        volumes = [
          "/var/lib/sun-panel:/app/conf"
        ];
        ports = [ "8085:3002" ];
      };
    };
  };
  services.caddy.virtualHosts."home.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8085
    '';
  };
}
