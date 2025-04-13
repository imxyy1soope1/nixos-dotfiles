{ ... }:
{
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "matrix.imxyy.top";
      public_baseurl = "https://matrix.imxyy.top";
      listeners = [
        {
          port = 8094;
          bind_addresses = [ "127.0.0.1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];
      turn_uris = [ "turns:vkvm.imxyy.top:5349" ];
      turn_shared_secret = "ac779a48c03bb451839569d295a29aa6ab8c264277bec2df9c9c7f5e22936288";
      turn_user_lifetime = "1h";
      database_type = "psycopg2";
      database_args.database = "matrix-synapse";
    };
    extraConfigFiles = [
      "/var/lib/matrix-synapse/secret"
    ];
  };
  services.caddy.virtualHosts."matrix.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8094
      handle_path /_matrix {
        reverse_proxy :8094
      }
      handle_path /_synapse/client {
        reverse_proxy :8094
      }
    '';
  };
}
