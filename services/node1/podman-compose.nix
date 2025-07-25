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
  virtualisation.oci-containers.containers."node1-certbot" = {
    image = "localhost/compose2nix/node1-certbot";
    volumes = [
      "node1_certbot-cert:/etc/letsencrypt:rw"
      "node1_certbot-webroot:/var/www/certbot:rw"
    ];
    dependsOn = [
      "node1-nginx"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=certbot"
      "--network=node1_default"
    ];
  };
  systemd.services."podman-node1-certbot" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-build-node1-certbot.service"
      "podman-network-node1_default.service"
      "podman-volume-node1_certbot-cert.service"
      "podman-volume-node1_certbot-webroot.service"
    ];
    requires = [
      "podman-build-node1-certbot.service"
      "podman-network-node1_default.service"
      "podman-volume-node1_certbot-cert.service"
      "podman-volume-node1_certbot-webroot.service"
    ];
  };
  virtualisation.oci-containers.containers."node1-db" = {
    image = "mariadb:10.5";
    environment = {
      "MYSQL_DATABASE" = "nextcloud";
      "MYSQL_PASSWORD" = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
      "MYSQL_ROOT_PASSWORD" = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
      "MYSQL_USER" = "nextcloud";
    };
    volumes = [
      "node1_nextcloud_db:/var/lib/mysql:rw"
    ];
    cmd = [ "--transaction-isolation=READ-COMMITTED" "--binlog-format=ROW" ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=db"
      "--network=node1_default"
    ];
  };
  systemd.services."podman-node1-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-node1_default.service"
      "podman-volume-node1_nextcloud_db.service"
    ];
    requires = [
      "podman-network-node1_default.service"
      "podman-volume-node1_nextcloud_db.service"
    ];
  };
  virtualisation.oci-containers.containers."node1-nextcloud" = {
    image = "nextcloud:fpm";
    environment = {
      "MYSQL_DATABASE" = "nextcloud";
      "MYSQL_HOST" = "db";
      "MYSQL_PASSWORD" = "hahahahahfakjhsdakj;fmvqop[i23409lckxnmvarioavokmqpoauiegvna[wos;kildz/5tklvahuipta;sjlvbihpua;kjtr]]";
      "MYSQL_USER" = "nextcloud";
    };
    volumes = [
      "node1_nextcloud_html:/var/www/html:rw"
    ];
    dependsOn = [
      "node1-db"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=nextcloud"
      "--network=node1_default"
    ];
  };
  systemd.services."podman-node1-nextcloud" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-node1_default.service"
      "podman-volume-node1_nextcloud_html.service"
    ];
    requires = [
      "podman-network-node1_default.service"
      "podman-volume-node1_nextcloud_html.service"
    ];
  };
  virtualisation.oci-containers.containers."node1-nextcloud-cron" = {
    image = "nextcloud:fpm";
    volumes = [
      "node1_nextcloud_html:/var/www/html:rw"
    ];
    dependsOn = [
      "node1-nextcloud"
      "node1-nginx"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--entrypoint=[\"/cron.sh\"]"
      "--network-alias=nextcloud-cron"
      "--network=node1_default"
    ];
  };
  systemd.services."podman-node1-nextcloud-cron" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-node1_default.service"
      "podman-volume-node1_nextcloud_html.service"
    ];
    requires = [
      "podman-network-node1_default.service"
      "podman-volume-node1_nextcloud_html.service"
    ];
  };
  virtualisation.oci-containers.containers."node1-nginx" = {
    image = "localhost/compose2nix/node1-nginx";
    volumes = [
      "node1_certbot-cert:/etc/letsencrypt:ro"
      "node1_certbot-webroot:/var/www/certbot:ro"
    ];
    ports = [
      "80:80/tcp"
      "443:443/tcp"
      "1935:1935/tcp"
    ];
    dependsOn = [
      "node1-nextcloud"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=nginx"
      "--network=node1_default"
    ];
  };
  systemd.services."podman-node1-nginx" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-build-node1-nginx.service"
      "podman-network-node1_default.service"
      "podman-volume-node1_certbot-cert.service"
      "podman-volume-node1_certbot-webroot.service"
    ];
    requires = [
      "podman-build-node1-nginx.service"
      "podman-network-node1_default.service"
      "podman-volume-node1_certbot-cert.service"
      "podman-volume-node1_certbot-webroot.service"
    ];
  };
  virtualisation.oci-containers.containers."node1-prod-postgres" = {
    image = "postgres";
    environment = {
      "POSTGRES_PASSWORD" = "Pornhub.com";
    };
    volumes = [
      "node1_postgress_db:/var/lib/postgresql/data:rw"
    ];
    ports = [
      "5432:5432/tcp"
    ];
    log-driver = "journald";
    autoStart = false;
    extraOptions = [
      "--network-alias=prod-postgres"
      "--network=node1_default"
    ];
  };
  systemd.services."podman-node1-prod-postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-node1_default.service"
      "podman-volume-node1_postgress_db.service"
    ];
    requires = [
      "podman-network-node1_default.service"
      "podman-volume-node1_postgress_db.service"
    ];
  };

  # Networks
  systemd.services."podman-network-node1_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f node1_default";
    };
    script = ''
      podman network inspect node1_default || podman network create node1_default
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };

  # Volumes
  systemd.services."podman-volume-node1_certbot-cert" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect node1_certbot-cert || podman volume create node1_certbot-cert
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };
  systemd.services."podman-volume-node1_certbot-webroot" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect node1_certbot-webroot || podman volume create node1_certbot-webroot
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };
  systemd.services."podman-volume-node1_nextcloud_db" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect node1_nextcloud_db || podman volume create node1_nextcloud_db
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };
  systemd.services."podman-volume-node1_nextcloud_html" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect node1_nextcloud_html || podman volume create node1_nextcloud_html
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };
  systemd.services."podman-volume-node1_postgress_db" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect node1_postgress_db || podman volume create node1_postgress_db
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };

  # Builds
  systemd.services."podman-build-node1-certbot" = {
    path = [ pkgs.podman pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutSec = 300;
    };
    script = ''
      cd /home/rubogubo/Projects/clan-config/containers/certbotdocker
      podman build -t compose2nix/node1-certbot .
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };
  systemd.services."podman-build-node1-nginx" = {
    path = [ pkgs.podman pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutSec = 300;
    };
    script = ''
      cd /home/rubogubo/Projects/clan-config/containers/nginx
      podman build -t compose2nix/node1-nginx .
    '';
    partOf = [ "podman-compose-node1-root.target" ];
    wantedBy = [ "podman-compose-node1-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-node1-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
  };
}
