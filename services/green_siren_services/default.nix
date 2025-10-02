{ ... }:
{
  _class = "clan.service";
  manifest.name = "Green Siren Services";
  manifest.description = "Sets up the services for Green Siren. Please make sure to run `just build` first.";
  manifest.categories = [ "Services" ];

  roles.default.perInstance.nixosModule.imports = [
    # For now turn this off and just run it manually
    # ./podman-compose.nix
    # ./containers.nix]
    ./gss_user.nix
    ./podman.nix
    ./deploy_files.nix
  ];
}
