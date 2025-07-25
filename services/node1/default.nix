{ ... }:
{
  _class = "clan.service";
  manifest.name = "Node 1 Configuration";
  manifest.description = "Sets up the services for node one. Please make sure to run `just build` first.";
  manifest.categories = [ "Services" ];

  roles.default.perInstance.nixosModule.imports = [ ./podman-compose.nix ];
}
