{ lib, pkgs, ... }:
{
  virtualisation.oci-containers.containers."green_siren_services-nginx".imageStream =
    import ./nginx/container.nix
      { inherit pkgs; };

  virtualisation.oci-containers.containers."green_siren_services-nginx".image = lib.mkForce "";

}
