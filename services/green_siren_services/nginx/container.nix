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
    touch var/log/nginx/error.log
    touch var/log/nginx/access.log
  '';

  fakeRootCommands = ''
    #!${pkgs.stdenv.shell}
    ${pkgs.dockerTools.shadowSetup}
    groupadd --system nginx
    useradd --system --gid nginx nginx
    chown -R nginx:nginx var/log/nginx
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
