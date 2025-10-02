{ pkgs, ... }:
let
  nginx-container = import ./podman/nginx/container.nix { inherit pkgs; };
in
{
  virtualisation.oci-containers.containers."green_siren_services-nginx".imageStream = nginx-container;

  virtualisation.oci-containers.containers."green_siren_services-nginx".image =
    "nginx-container:latest";
}
