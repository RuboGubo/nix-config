{
  pkgs,
  lib,
  inputs,
  secret-env-path,
  ...
}:
{
  project.name = "gss";

  # In Arion, global volumes must be under the docker-compose attribute
  docker-compose.volumes = {
    postgres_db = { };
    nextcloud_db = { };
    nextcloud_html = { };
    certbot-webroot = { };
    certbot-cert = { };
  };

  services = {
    debug-tool.service = {
      image = "nixery.dev/shell/iputils/postgresql/bash";
      # Keeps the container alive so you can exec into it
      command = [ "sleep" "infinity" ];
    };
    
    primes = {
      build.image = lib.mkForce (inputs.primes.packages.${pkgs.system}.container);
      service = {
        useHostStore = true;
        restart = "unless-stopped";
        ports = [ "8000:8000" ];
        env_file = [ secret-env-path ];
        depends_on = [ "prod-postgres" ];
      };
    };

    prod-postgres.service = {
      image = "postgres:17";
      restart = "unless-stopped";
      ports = [ "5432:5432" ];
      env_file = [ secret-env-path ];
      volumes = [
        "postgres_db:/var/lib/postgresql/data"
      ];
    };

  };
}
