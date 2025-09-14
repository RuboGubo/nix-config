{ pkgs, ... }:
let
  rootfs = pkgs.runCommand "nginx-extra-files" { } ''
    mkdir -p $out/etc/nginx
    cp -r ${./config}/* $out/etc/nginx/

    mkdir -p $out/static_sites
    cp -r ${./static_websites}/* $out/static_sites/
  '';
in
pkgs.dockerTools.streamLayeredImage {
  name = "nginx-container";
  tag = "latest";

  contents = [
    pkgs.nginx
    rootfs
  ];

  extraCommands = ''
    mkdir -p var/log/nginx
    mkdir -p var/www/certbot
    touch var/log/nginx/error.log
    touch var/log/nginx/access.log
    chmod 755 var/log/nginx
    chmod 644 var/log/nginx/error.log
    chmod 644 var/log/nginx/access.log
  '';

  fakeRootCommands = ''
    mkdir -p etc var/cache/nginx

    # Create minimal passwd and group files
    echo "root:x:0:0:root:/root:/bin/sh" > etc/passwd
    echo "nginx:x:101:101:nginx:/var/cache/nginx:/sbin/nologin" >> etc/passwd
    echo "nobody:x:65534:65534:nobody:/tmp:/sbin/nologin" >> etc/passwd

    echo "root:x:0:" > etc/group
    echo "nginx:x:101:" >> etc/group
    echo "nobody:x:65534:" >> etc/group

    # Set proper ownership using numeric IDs
    chown -R 101:101 var/log/nginx var/www/certbot var/cache/nginx
  '';

  config = {
    Cmd = [
      "/bin/nginx"
      "-g"
      "daemon off;"
    ];
    ExposedPorts = {
      "80/tcp" = { };
      "443/tcp" = { };
    };
  };
}
