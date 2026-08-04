{ inputs, aspects, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    aspects.local.desktop.nixos
    aspects.ssh.nixos
    aspects.rubogubo.desktop.nixos
    aspects.hanseo.desktop.nixos
  ];
}
