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

  config = {
    Cmd = [
      "nginx"
      "-g"
      "daemon off;"
    ];
    ExposedPorts = {
      "80/tcp" = { };
      "443/tcp" = { };
    };
  };
}
