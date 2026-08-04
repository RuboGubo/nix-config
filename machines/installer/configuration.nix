{
  config,
  clan-core,
  inputs,
  ...
}:
{
  imports = [
    ./disko.nix
    clan-core.nixosModules.installer
    inputs.self.aspects.machines.installer.nixos
  ];

  clan.core.deployment.requireExplicitUpdate = true;

  nixpkgs.pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  system.stateVersion = config.system.nixos.release;
}
