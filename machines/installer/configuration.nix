{
  config,
  clan-core,
  inputs,
  aspects,
  ...
}:
{
  imports = [
    ./disko.nix
    clan-core.nixosModules.installer
    aspects.machines.installer.nixos
  ];

  clan.core.deployment.requireExplicitUpdate = true;

  nixpkgs.pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  system.stateVersion = config.system.nixos.release;
}
