{ inputs, aspects, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    aspects.local.desktop.nixos
    aspects.rubogubo.desktop.nixos
    aspects.rubogubo.ssh.nixos
    aspects.ssh.known-hosts.nixos
  ];
}
