{ ... }:
{
  _class = "clan.service";
  manifest.name = "RuboGubo";
  manifest.description = "The RuboGubo User";
  manifest.categories = [ "User" ];

  roles.server.perInstance.nixosModule =
    { inputs, ... }:
    {
      imports = [ ./common.nix ];
      home-manager.users."rubogubo".imports = [];
    };
  roles.desktop.perInstance.nixosModule.imports = [
    ./desktop.nix
    ./podman.nix
  ];
}
