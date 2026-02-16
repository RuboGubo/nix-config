{ pkgs, ... }:
let
  domains = [
    "greensiren.co.uk"
    "portainer.greensiren.co.uk"
    "primes.greensiren.co.uk"
    "nextcloud.greensiren.co.uk"
    "documentation.greensiren.co.uk"
    "mail.greensiren.co.uk"
    "ticket-plus.greensiren.co.uk"
    "backend-ticket-plus.greensiren.co.uk"
    "api.primes.greensiren.co.uk"
    "swimming.greensiren.co.uk"
    "valentines.greensiren.co.uk"
  ];
in
pkgs.dockerTools.streamLayeredImage {
  name = "certbot-greensiren";
  tag = "latest";

  contents = [ pkgs.certbot ];

  config = {
    Cmd = [
      "certonly"
      "--webroot"
      "--expand"
      "--agree-tos"
      "--non-interactive"
      "-w"
      "/var/www/certbot/"
      "-m"
      "admin@greensiren.co.uk"
    ]
    ++ pkgs.lib.concatMap (d: [
      "-d"
      d
    ]) domains;

    WorkingDir = "/";
  };
}
