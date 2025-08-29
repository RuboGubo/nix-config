{pkgs, ...}: {
  virtualisation.oci-containers.containers."green_siren_services-nginx".imageStream = pkgs.dockerTools.streamLayeredImage
}
