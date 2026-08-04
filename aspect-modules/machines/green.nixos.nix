{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.self.aspects.local.desktop.nixos
    inputs.self.aspects.rubogubo.desktop.nixos
  ];
}
