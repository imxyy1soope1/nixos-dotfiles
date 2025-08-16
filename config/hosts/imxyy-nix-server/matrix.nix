{
  config,
  secrets,
  ...
}:
{
  sops.secrets.tuwunel-reg-token = {
    sopsFile = secrets.tuwunel-reg-token;
    format = "binary";
    owner = config.services.matrix-tuwunel.user;
    group = config.services.matrix-tuwunel.group;
  };
  services.matrix-tuwunel = {
    enable = true;
    settings.global = {
      address = [ "127.0.0.1" ];
      port = [ 8094 ];
      server_name = "imxyy.top";
      allow_registration = true;
      registration_token_file = config.sops.secrets.tuwunel-reg-token.path;
      well_known = {
        server = "matrix.imxyy.top:443";
        client = "https://matrix.imxyy.top";
      };
    };
  };
  services.caddy.virtualHosts."imxyy.top" = {
    extraConfig = ''
      handle /.well-known/matrix/server {
        header Content-Type application/json
        header "Access-Control-Allow-Origin" "*"

        respond `{"m.server": "matrix.imxyy.top:443"}` 200
      }
      handle /.well-known/matrix/client {
        header Content-Type application/json
        header "Access-Control-Allow-Origin" "*"

        respond `{"m.homeserver": {"base_url": "https://matrix.imxyy.top/"}}` 200
      }
    '';
  };
  services.caddy.virtualHosts."matrix.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8094
    '';
  };
}
