# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."green_siren_services-db" = {
    image = "mariadb:10.5";
    environment = {
      "MYSQL_DATABASE" = "nextcloud";
      "MYSQL_PASSWORD" =
        "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
      "MYSQL_ROOT_PASSWORD" =
        "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
      "MYSQL_USER" = "nextcloud";
    };
    volumes = [
      "green_siren_services_nextcloud_db:/var/lib/mysql:rw"
    ];
    cmd = [
      "--transaction-isolation=READ-COMMITTED"
      "--binlog-format=ROW"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=db"
      "--network=green_siren_services_default"
    ];
  };
  systemd.services."podman-green_siren_services-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_nextcloud_db.service"
    ];
    requires = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_nextcloud_db.service"
    ];
  };
  virtualisation.oci-containers.containers."green_siren_services-nextcloud" = {
    image = "nextcloud:fpm";
    environment = {
      "MYSQL_DATABASE" = "nextcloud";
      "MYSQL_HOST" = "db";
      "MYSQL_PASSWORD" =
        "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
      "MYSQL_USER" = "nextcloud";
    };
    volumes = [
      "green_siren_services_nextcloud_html:/var/www/html:rw"
    ];
    dependsOn = [
      "green_siren_services-db"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=nextcloud"
      "--network=green_siren_services_default"
    ];
  };
  systemd.services."podman-green_siren_services-nextcloud" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_nextcloud_html.service"
    ];
    requires = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_nextcloud_html.service"
    ];
  };
  virtualisation.oci-containers.containers."green_siren_services-nextcloud-cron" = {
    image = "nextcloud:fpm";
    volumes = [
      "green_siren_services_nextcloud_html:/var/www/html:rw"
    ];
    dependsOn = [
      "green_siren_services-nextcloud"
      "green_siren_services-nginx"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--entrypoint=[\"/cron.sh\"]"
      "--network-alias=nextcloud-cron"
      "--network=green_siren_services_default"
    ];
  };
  systemd.services."podman-green_siren_services-nextcloud-cron" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_nextcloud_html.service"
    ];
    requires = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_nextcloud_html.service"
    ];
  };
  virtualisation.oci-containers.containers."green_siren_services-nginx" = {
    # image = "temp/temp";
    volumes = [
      "green_siren_services_certbot-cert:/etc/letsencrypt:ro"
      "green_siren_services_certbot-webroot:/var/www/certbot:ro"
    ];
    ports = [
      "80:80/tcp"
      "443:443/tcp"
      "1935:1935/tcp"
    ];
    dependsOn = [
      "green_siren_services-nextcloud"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=nginx"
      "--network=green_siren_services_default"
    ];
  };
  systemd.services."podman-green_siren_services-nginx" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_certbot-cert.service"
      "podman-volume-green_siren_services_certbot-webroot.service"
    ];
    requires = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_certbot-cert.service"
      "podman-volume-green_siren_services_certbot-webroot.service"
    ];
  };
  virtualisation.oci-containers.containers."green_siren_services-prod-postgres" = {
    image = "postgres";
    environment = {
      "POSTGRES_PASSWORD" = "Pornhub.com";
    };
    volumes = [
      "green_siren_services_postgress_db:/var/lib/postgresql/data:rw"
    ];
    ports = [
      "5432:5432/tcp"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=prod-postgres"
      "--network=green_siren_services_default"
    ];
  };
  systemd.services."podman-green_siren_services-prod-postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_postgress_db.service"
    ];
    requires = [
      "podman-network-green_siren_services_default.service"
      "podman-volume-green_siren_services_postgress_db.service"
    ];
  };

  # Networks
  systemd.services."podman-network-green_siren_services_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f green_siren_services_default";
    };
    script = ''
      podman network inspect green_siren_services_default || podman network create green_siren_services_default
    '';
    partOf = [ "podman-compose-green_siren_services-root.target" ];
    wantedBy = [ "podman-compose-green_siren_services-root.target" ];
  };

  # Volumes
  systemd.services."podman-volume-green_siren_services_certbot-cert" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect green_siren_services_certbot-cert || podman volume create green_siren_services_certbot-cert
    '';
    partOf = [ "podman-compose-green_siren_services-root.target" ];
    wantedBy = [ "podman-compose-green_siren_services-root.target" ];
  };
  systemd.services."podman-volume-green_siren_services_certbot-webroot" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect green_siren_services_certbot-webroot || podman volume create green_siren_services_certbot-webroot
    '';
    partOf = [ "podman-compose-green_siren_services-root.target" ];
    wantedBy = [ "podman-compose-green_siren_services-root.target" ];
  };
  systemd.services."podman-volume-green_siren_services_nextcloud_db" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect green_siren_services_nextcloud_db || podman volume create green_siren_services_nextcloud_db
    '';
    partOf = [ "podman-compose-green_siren_services-root.target" ];
    wantedBy = [ "podman-compose-green_siren_services-root.target" ];
  };
  systemd.services."podman-volume-green_siren_services_nextcloud_html" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect green_siren_services_nextcloud_html || podman volume create green_siren_services_nextcloud_html
    '';
    partOf = [ "podman-compose-green_siren_services-root.target" ];
    wantedBy = [ "podman-compose-green_siren_services-root.target" ];
  };
  systemd.services."podman-volume-green_siren_services_postgress_db" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect green_siren_services_postgress_db || podman volume create green_siren_services_postgress_db
    '';
    partOf = [ "podman-compose-green_siren_services-root.target" ];
    wantedBy = [ "podman-compose-green_siren_services-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-green_siren_services-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
  };
}
