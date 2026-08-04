{ inputs, aspects, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    aspects.local.common.nixos
    aspects.ssh.nixos
    aspects.rubogubo.server.nixos
    aspects.gss.server.nixos
  ];
}
