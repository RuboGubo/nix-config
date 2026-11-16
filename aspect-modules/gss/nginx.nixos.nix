{ ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@greensiren.co.uk";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    # Keep legacy TLS termination and certificates in Compose. Only Firefly's
    # SNI name is routed to the NixOS HTTPS virtual host below.
    streamConfig = ''
      map $ssl_preread_server_name $tls_backend {
        firefly.greensiren.co.uk 127.0.0.1:8443;
        default                 127.0.0.1:8444;
      }

      server {
        listen 0.0.0.0:443;
        listen [::]:443;
        ssl_preread on;
        proxy_pass $tls_backend;
        proxy_connect_timeout 10s;
        proxy_timeout 7d;
      }
    '';

    virtualHosts = {
      # This also forwards legacy Certbot HTTP-01 challenges to Compose.
      "compose-fallback" = {
        default = true;
        serverName = "_";
        # Let the existing virtual hosts enforce their own upload limits.
        extraConfig = "client_max_body_size 0;";
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "[::]";
            port = 80;
          }
        ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081";
          proxyWebsockets = true;
          extraConfig = "proxy_read_timeout 7d;";
        };
      };

      "firefly.greensiren.co.uk" = {
        enableACME = true;
        forceSSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "[::]";
            port = 80;
          }
          {
            addr = "127.0.0.1";
            port = 8443;
            ssl = true;
          }
        ];
        extraConfig = "port_in_redirect off;";
      };
    };
  };
}
