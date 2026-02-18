{ ... }:
{
  _class = "clan.service";
  manifest.name = "RuboGubo";
  manifest.description = "The RuboGubo User";
  manifest.categories = [ "User" ];

  roles.server.perInstance.nixosModule.imports = [
    ./common.nix 
    ./server.nix 
  ];
  roles.desktop.perInstance.nixosModule.imports = [
    ./desktop.nix
    ./podman.nix
  ];
}
