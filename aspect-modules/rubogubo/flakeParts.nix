{ self, ... }:
{
  clan.modules.rubogubo = {
    _class = "clan.service";
    manifest.name = "RuboGubo";
    manifest.description = "The RuboGubo User";
    manifest.categories = [ "User" ];

    roles.server.perInstance.nixosModule = {
      imports = [ self.aspects.rubogubo.server.nixos ];
    };

    roles.desktop.perInstance.nixosModule = {
      imports = [ self.aspects.rubogubo.desktop.nixos ];
    };
  };
}
