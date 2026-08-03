{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  users.users."rubogubo".packages = [ pkgs.podman-compose ];
}
