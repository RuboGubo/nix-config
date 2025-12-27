{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  project.name = "green_siren_services";

  services = {
    # Your Rust application
    primes = {
      service.useHostStore = true;
      
      build.image = lib.mkForce (inputs.primes.packages.${pkgs.system}.container);

      service.restart = "unless-stopped";

      service.ports = [
        "8000:8000"
      ];

      # Add any environment variables your app needs
      service.environment = {
        # RUST_LOG = "info";
        # DATABASE_URL = "postgresql://nextcloud:password@prod-postgres:5432/nextcloud";
      };

      # Add volumes if needed
      # service.volumes = [
      #   "./config:/app/config:ro"
      # ];

      # If your app depends on the database
      service.depends_on = [ "prod-postgres" ];
    };

    prod-postgres = {
      service.useHostStore = true;

      # If you have a custom postgres image from inputs
      # image.command = inputs.otherFlake.packages.${system}.postgresImage;
      # Otherwise use docker image name:
      image.name = "postgres";

      service.restart = "unless-stopped";

      service.ports = [
        "5432:5432"
      ];

      service.environment = {
        POSTGRES_PASSWORD = "Pornhub.com";
      };

      service.volumes = [
        "postgress_db:/var/lib/postgresql/data"
      ];
    };

    # Commented out portainer - uncomment if needed
    # portainer = {
    #   service.useHostStore = true;
    #   image.name = "portainer/portainer-ee:latest";
    #   service.container_name = "portainer";
    #   service.restart = "unless-stopped";
    #
    #   service.volumes = [
    #     "/etc/localtime:/etc/localtime:ro"
    #     "/var/run/docker.sock:/var/run/docker.sock:ro"
    #     "../docker-data/portainer-data:/data"
    #   ];
    #
    #   service.ports = [
    #     "9000:9000"
    #   ];
    #
    #   docker-compose.raw.security_opt = [
    #     "no-new-privileges:true"
    #   ];
    # };

    # db = {
    #   service.useHostStore = true;
    #   image.name = "mariadb:10.5";
    #   service.restart = "always";
    #   service.command = [
    #     "--transaction-isolation=READ-COMMITTED"
    #     "--binlog-format=ROW"
    #   ];

    #   service.volumes = [
    #     "nextcloud_db:/var/lib/mysql"
    #   ];

    #   service.environment = {
    #     MYSQL_ROOT_PASSWORD = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
    #     MYSQL_PASSWORD = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
    #     MYSQL_DATABASE = "nextcloud";
    #     MYSQL_USER = "nextcloud";
    #   };
    # };

    # nextcloud = {
    #   service.useHostStore = true;
    #   image.name = "nextcloud:fpm";
    #   service.restart = "always";

    #   service.volumes = [
    #     "nextcloud_html:/var/www/html"
    #   ];

    #   service.environment = {
    #     MYSQL_PASSWORD = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
    #     MYSQL_DATABASE = "nextcloud";
    #     MYSQL_USER = "nextcloud";
    #     MYSQL_HOST = "db";
    #   };

    #   service.depends_on = [ "db" ];
    # };

    # Commented out nextcloud-cron - uncomment if needed
    # nextcloud-cron = {
    #   service.useHostStore = true;
    #   image.name = "nextcloud:fpm";
    #   service.restart = "always";
    #
    #   service.volumes = [
    #     "nextcloud_html:/var/www/html"
    #   ];
    #
    #   service.entrypoint = "/cron.sh";
    #   service.depends_on = [ "nextcloud" "nginx" ];
    # };

    # nginx = {
    #   service.useHostStore = true;

    #   # Reference your Nix-built image from inputs
    #   image.command = inputs.otherFlake.packages.${system}.nginxImage;

    #   service.restart = "always";

    #   service.ports = [
    #     "80:80"
    #     "443:443"
    #   ];

    #   service.volumes = [
    #     "certbot-webroot:/var/www/certbot/:ro"
    #     "certbot-cert:/etc/letsencrypt/:ro"
    #     "nextcloud_html:/var/www/html"
    #     # Uncomment as needed:
    #     # "../docker-data/radio/:/radio/:ro"
    #     # "./nginx/static_websites/:/static_websites/:ro"
    #   ];

    #   service.depends_on = [ "nextcloud" ];

    #   # Uncomment if you need CI_JOB_TOKEN:
    #   # service.environment = {
    #   #   CI_JOB_TOKEN = "\${CI_JOB_TOKEN}";
    #   # };
    # };

    # certbot = {
    #   service.useHostStore = true;

    #   # Reference your Nix-built certbot image from inputs
    #   image.command = inputs.otherFlake.packages.${system}.certbotImage;

    #   service.volumes = [
    #     "certbot-webroot:/var/www/certbot/:rw"
    #     "certbot-cert:/etc/letsencrypt/:rw"
    #   ];

    #   service.depends_on = [ "nginx" ];
    # };
  };

  # Define volumes
  docker-compose.raw = {
    volumes = {
      postgress_db = { };
      nextcloud_db = { };
      nextcloud_html = { };
      certbot-webroot = { };
      certbot-cert = { };
    };
  };
}
