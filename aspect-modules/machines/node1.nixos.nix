{ inputs, aspects, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    aspects.local.common.nixos
    aspects.rubogubo.server.nixos
  ];
}
