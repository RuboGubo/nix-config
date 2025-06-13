{settings, pkgs, ...}: {
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      autoPrune.enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  systemd.services."podman-compose" = {
      path = [ pkgs.podman pkgs.podman-compose ];
      script = ''
        podman-compose -f "${settings.path}" up
      '';
      wantedBy = ["multi-user.target"];
      # If you use podman
      after = ["podman.service" "podman.socket"];
      # If you use docker
      # after = ["docker.service" "docker.socket"];
  };
}