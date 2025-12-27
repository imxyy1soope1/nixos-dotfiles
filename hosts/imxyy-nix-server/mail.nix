{ pkgs, ... }:
{
  services.roundcube = {
    enable = true;
    hostName = "mail.imxyy.top";
    plugins = [
      "contextmenu"
      "persistent_login"
    ];
    package = pkgs.roundcube.withPlugins (
      plugins: with plugins; [
        contextmenu
        persistent_login
      ]
    );
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['imap_conn_options'] = [
        'ssl' => [
          'verify_peer_name' => false,
        ],
      ];
      $config['imap_host'] = "tls://mail10.serv00.com";
      $config['imap_user'] = "%u";
      $config['imap_pass'] = "%p";
      $config['smtp_conn_options'] = [
        'ssl' => [
          'verify_peer_name' => false,
        ],
      ];
      $config['smtp_host'] = "tls://mail10.serv00.com";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };
  services.nginx.virtualHosts."mail.imxyy.top" = {
    listen = [
      {
        addr = "0.0.0.0";
        port = 8087;
      }
    ];
    forceSSL = false;
    enableACME = false;
  };
  services.caddy.virtualHosts."mail.imxyy.top" = {
    extraConfig = ''
      reverse_proxy :8087 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
