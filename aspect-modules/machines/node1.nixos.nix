{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.self.aspects.local.common.nixos
    inputs.self.aspects.rubogubo.server.nixos
  ];
}
