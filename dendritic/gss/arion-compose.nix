{
  pkgs,
  lib,
  inputs,
  secret-env-path,
  enableCertbot ? false,
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
      command = [
        "sleep"
        "infinity"
      ];
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

    nginx.service = {
      image = "nginx:alpine";
      restart = "unless-stopped";
      ports = [
        "80:80"
        "443:443"
      ];
      volumes = [
        "${./nginx/config/nginx.conf}:/etc/nginx/nginx.conf:ro"
        "${./nginx/config/error.conf}:/etc/nginx/error.conf:ro"
        "${./nginx/config/ssl.conf}:/etc/nginx/ssl.conf:ro"
        "${./nginx/static_websites}:/static_websites:ro"
        "certbot-webroot:/var/www/certbot:ro"
        "certbot-cert:/etc/letsencrypt:ro"
      ];
      depends_on = [
        "primes"
        "nextcloud"
      ];
    };

    certbot.service = lib.mkIf enableCertbot {
      image = "certbot/certbot:latest";
      command = [
        "certonly"
        "--webroot"
        "--expand"
        "--agree-tos"
        "--non-interactive"
        "-w"
        "/var/www/certbot/"
        "-m"
        "admin@greensiren.co.uk"
        "--domains"
        "greensiren.co.uk,portainer.greensiren.co.uk,primes.greensiren.co.uk,nextcloud.greensiren.co.uk,documentation.greensiren.co.uk,mail.greensiren.co.uk,ticket-plus.greensiren.co.uk,backend-ticket-plus.greensiren.co.uk,api.primes.greensiren.co.uk,swimming.greensiren.co.uk"
      ];
      volumes = [
        "certbot-webroot:/var/www/certbot/:rw"
        "certbot-cert:/etc/letsencrypt/:rw"
      ];
      depends_on = [ "nginx" ];
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

    nextcloud.service = {
      image = "nextcloud:fpm";
      restart = "unless-stopped";
      volumes = [
        "nextcloud_html:/var/www/html"
      ];
      environment = {
        MYSQL_PASSWORD = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
        MYSQL_DATABASE = "nextcloud";
        MYSQL_USER = "nextcloud";
        MYSQL_HOST = "nextcloud-db";
      };
      depends_on = [ "nextcloud-db" ];
    };

    nextcloud-db.service = {
      image = "mariadb:10.5";
      restart = "unless-stopped";
      command = [
        "--transaction-isolation=READ-COMMITTED"
        "--binlog-format=ROW"
      ];
      volumes = [
        "nextcloud_db:/var/lib/mysql"
      ];
      environment = {
        MYSQL_ROOT_PASSWORD = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
        MYSQL_PASSWORD = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
        MYSQL_DATABASE = "nextcloud";
        MYSQL_USER = "nextcloud";
      };
    };
  };
}
