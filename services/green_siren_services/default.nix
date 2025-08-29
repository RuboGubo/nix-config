{ ... }:
{
  _class = "clan.service";
  manifest.name = "Green Siren Services";
  manifest.description = "Sets up the services for Green Siren. Please make sure to run `just build` first.";
  manifest.categories = [ "Services" ];

  roles.default.perInstance.nixosModule.imports = [
    ./podman-compose.nix
    ./containers.nix
  ];
}
