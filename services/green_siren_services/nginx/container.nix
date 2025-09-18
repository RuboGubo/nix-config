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
    pkgs.dockerTools.fakeNss
    pkgs.nginx
    rootfs
  ];

  extraCommands = ''
    mkdir -p tmp/nginx_client_body

    mkdir -p var/log/nginx
    mkdir -p var/cache/nginx
  '';

  # ${pkgs.dockerTools.shadowSetup}
  # #!${pkgs.stdenv.shell}
  # # ${pkgs.dockerTools.shadowSetup}
  # groupadd --system nogroup
  # useradd -r -g nobody nobody
  fakeRootCommands = '''';
  # useradd --system --gid nginx nginx

  config = {
    Cmd = [
      "/bin/nginx"
    ];
    ExposedPorts = {
      "80/tcp" = { };
      "443/tcp" = { };
    };
  };
}
