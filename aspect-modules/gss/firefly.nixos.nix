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
    };
  };
}
