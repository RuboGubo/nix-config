{ config, pkgs, ... }:
{
  clan.core.vars.generators.firefly = {
    files.app-key = {
      secret = true;
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
      mode = "0400";
    };
    runtimeInputs = [ pkgs.openssl ];
    script = ''
      printf 'base64:' > "$out/app-key"
      openssl rand -base64 32 >> "$out/app-key"
    '';
  };

  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    virtualHost = "firefly.greensiren.co.uk";
    settings = {
      APP_URL = "https://firefly.greensiren.co.uk";
      APP_KEY_FILE = config.clan.core.vars.generators.firefly.files.app-key.path;
      DB_CONNECTION = "sqlite";
      DEFAULT_LANGUAGE = "en_GB";
      DEFAULT_LOCALE = "en_GB";
    };
  };

  services.firefly-iii-data-importer = {
    enable = true;
    enableNginx = true;
    virtualHost = "firefly-importer.greensiren.co.uk";
    settings = {
      FIREFLY_III_URL = config.services.firefly-iii.settings.APP_URL;
      FALLBACK_LOCALE = "en_GB";
      # Leave the client ID unset so it can be entered in the web UI.
    };
  };

  services.nginx.virtualHosts.${config.services.firefly-iii-data-importer.virtualHost} = {
    enableACME = true;
    forceSSL = true;
    # Share Firefly's host TLS listener behind the SNI frontend.
    listen = config.services.nginx.virtualHosts.${config.services.firefly-iii.virtualHost}.listen;
    extraConfig = "port_in_redirect off;";
  };
}
