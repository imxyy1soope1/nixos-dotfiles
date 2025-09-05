{
  config,
  secrets,
  ...
}:
{
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  sops.secrets.tuwunel-reg-token = {
    sopsFile = secrets.tuwunel-reg-token;
    format = "binary";
    owner = config.services.matrix-tuwunel.user;
    group = config.services.matrix-tuwunel.group;
  };
  sops.secrets.tuwunel-turn-secret = {
    sopsFile = secrets.tuwunel-turn-secret;
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
      well_known = {
        server = "matrix.imxyy.top:443";
        client = "https://matrix.imxyy.top";
      };

      allow_registration = true;
      registration_token_file = config.sops.secrets.tuwunel-reg-token.path;

      suppress_push_when_active = true;

      turn_uris = [
        "turn:hk.vkvm.imxyy.top?transport=udp"
        "turn:hk.vkvm.imxyy.top?transport=tcp"
      ];
      turn_secret_file = config.sops.secrets.tuwunel-turn-secret.path;

      new_user_displayname_suffix = "";
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

  sops.secrets.mautrix-telegram = {
    sopsFile = secrets.mautrix-telegram;
    format = "dotenv";
    owner = "mautrix-telegram";
    group = "mautrix-telegram";
  };
  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.sops.secrets.mautrix-telegram.path;
    settings = {
      homeserver = {
        address = "http://127.0.0.1:8094";
        domain = "imxyy.top";
      };
      appservice = {
        address = "http://127.0.0.1:8098";
        hostname = "127.0.0.1";
        port = "8098";
        bot_username = "telegrambot";
      };
      bridge = {
        username_template = "telegram_{userid}";
        alias_template = "telegram_{groupname}";
        displayname_template = "{displayname} (Telegram)";
        permissions = {
          "@imxyy_soope_:imxyy.top" = "admin";
        };
      };
      telegram = {
        # borrowed from https://github.com/telegramdesktop/tdesktop/blob/9bdc19e2fd4d497c8f403891848383a88faadc25/snap/snapcraft.yaml#L134-L135
        api_id = "611335";
        api_hash = "d524b414d21f4d37f08684c1df41ac9c";
      };
    };
  };
}
