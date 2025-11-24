{
  services.coder = {
    enable = true;
    accessUrl = "https://coder.imxyy.top";
    listenAddress = "127.0.0.1:8086";
  };
  users.users.coder.extraGroups = [ "podman" ];
  services.caddy.virtualHosts."coder.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8086
    '';
  };
  my.services.frp.webServers = [ "coder.imxyy.top" ];
}
