{
  services.caddy.virtualHosts."linspirer.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8800
    '';
  };
  my.services.frp.webServers = [ "linspirer.imxyy.top" ];
}
