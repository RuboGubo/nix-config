{
  pkgs,
  lib,
  inputs,
  vars,
  enableCertbot ? true,
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
    recipes-static = { };
    recipes-media = { };
    sticks_stones_data = { };
  };

  services = {
    debug-tool.service = {
      image = "nixery.dev/shell/iputils/postgresql/bash";
      # Keeps the container alive so you can exec into it
      command = [
        "sleep"
        "infinity"
      ];
    };

    primes = {
      build.image = lib.mkForce (inputs.primes.packages.${pkgs.stdenv.hostPlatform.system}.container);
      service = {
        restart = "unless-stopped";
        ports = [ "8000:8000" ];
        env_file = [ vars.secret-env.path ];
        depends_on = [ "prod-postgres" ];
      };
    };

    sticks-and-stones = {
      service = {
        useHostStore = true;
        restart = "on-failure:5";
        ports = [ "8080:8080" ];
        env_file = [ vars.secret-env.path ];

        working_dir = "${inputs.sticks-and-stones.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin";

        volumes = [
          "sticks_stones_data:/data"
        ];

        # 2. Tell your app to create/read the DB in that writable folder
        environment = {
          # ?mode=rwc ensures SQLite creates the file if it doesn't exist
          DATABASE_URL = "sqlite:///data/app.sqlite3?mode=rwc";
          PORT = "8080";
          IP = "0.0.0.0";
        };

        # Point directly to the binary from the fullstack derivation
        command = [
          "${inputs.sticks-and-stones.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/web"
        ];
      };
    };

    nginx.service = {
      image = "nginx:latest";
      restart = "on-failure:5";
      ports = [
        "80:80"
        "443:443"
      ];
      volumes = [
        # Mount only our overrides. Mounting the entire directory 
        # hides important files
        "${./nginx/config/nginx.conf}:/etc/nginx/nginx.conf:ro"
        "${./nginx/config/error.conf}:/etc/nginx/error.conf:ro"
        "${./nginx/config/personal-website-common.conf}:/etc/nginx/personal-website-common.conf:ro"
        "${./nginx/config/ssl.conf}:/etc/nginx/ssl.conf:ro"
        "${./nginx/config/mime.types}:/etc/nginx/mime.types:ro"
        "${./nginx/config/discontinued.conf}:/etc/nginx/discontinued.conf:ro"
        "${./nginx/static_websites}:/static_websites:ro"
        # "${inputs.valentines.packages.${pkgs.stdenv.hostPlatform.system}.default}:/valentines:ro"
        "${
          inputs.personal-website.packages.${pkgs.stdenv.hostPlatform.system}.rendered
        }:/personal-website:ro"
        "certbot-webroot:/var/www/certbot:ro"
        "certbot-cert:/etc/letsencrypt:ro"
        "nextcloud_html:/var/www/html:ro"
      ];
      depends_on = [
        "primes"
        "nextcloud"
        "recipes"
        "sticks-and-stones"
      ];
    };

    certbot.service = lib.mkIf enableCertbot {
      image = "certbot/certbot:latest";
      command = [
        "certonly"
        "--webroot"
        "--expand"
        "--cert-name"
        "greensiren.co.uk"
        "--agree-tos"
        "--non-interactive"
        "-w"
        "/var/www/certbot/"
        "-m"
        "admin@greensiren.co.uk"
        "--domains"
        "greensiren.co.uk,sticks-and-stones.greensiren.co.uk,recipes.greensiren.co.uk,portainer.greensiren.co.uk,primes.greensiren.co.uk,nextcloud.greensiren.co.uk,documentation.greensiren.co.uk,mail.greensiren.co.uk,ticket-plus.greensiren.co.uk,backend-ticket-plus.greensiren.co.uk,api.primes.greensiren.co.uk,swimming.greensiren.co.uk,rubenward.com,hanseolee.com,rubogubo.com"
      ];
      volumes = [
        "certbot-webroot:/var/www/certbot/:rw"
        "certbot-cert:/etc/letsencrypt/:rw"
      ];
      depends_on = [ "nginx" ];
    };

    prod-postgres.service = {
      image = "postgres:17";
      restart = "on-failure:5";
      ports = [ "5432:5432" ];
      env_file = [ vars.secret-env.path ];
      environment = {
        POSTGRES_DB = "primes";
      };
      volumes = [
        "postgres_db:/var/lib/postgresql"
      ];
    };

    recipes.service = {
      restart = "on-failure:5";
      image = "vabene1111/recipes";
      ports = [ "80" ];
      env_file = [ vars.recipes-env.path ];
      volumes = [
        "recipes-static:/opt/recipes/staticfiles"
        "recipes-media:/opt/recipes/mediafiles"
      ];
      depends_on = [
        "prod-postgres"
      ];
    };

    nextcloud.service = {
      image = "nextcloud:fpm";
      restart = "on-failure:5";
      volumes = [
        "nextcloud_html:/var/www/html"
      ];
      env_file = [ vars.secret-env.path ];
      environment = {
        MYSQL_DATABASE = "nextcloud";
        MYSQL_USER = "nextcloud";
        MYSQL_HOST = "nextcloud-db";
      };
      depends_on = [ "nextcloud-db" ];
    };

    nextcloud-db.service = {
      image = "mariadb:10.5";
      restart = "on-failure:5";
      volumes = [
        "nextcloud_db:/var/lib/mysql"
      ];
      env_file = [ vars.secret-env.path ];
      environment = {
        MYSQL_DATABASE = "nextcloud";
        MYSQL_USER = "nextcloud";
      };
    };
  };
}
