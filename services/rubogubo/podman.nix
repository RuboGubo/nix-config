{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };
  
  users.users."rubogubo".packages = [ pkgs.podman-compose ];
}
