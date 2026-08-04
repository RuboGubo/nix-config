{ inputs, aspects, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    aspects.local.common.nixos
    aspects.rubogubo.server.nixos
    aspects.gss.server.nixos
    aspects.ssh.known-hosts.nixos
  ];
}
