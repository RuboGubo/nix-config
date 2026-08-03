{ self, ... }:
{
  clan.modules.local = {
    _class = "clan.service";
    manifest.name = "Local Settings";
    manifest.description = "Set the locale and input methods based on context";
    manifest.categories = [ "User" ];

    roles.server.perInstance.nixosModule = {
      imports = [ self.aspects.local.common.nixos ];
    };

    roles.desktop.perInstance.nixosModule = {
      imports = [ self.aspects.local.desktop.nixos ];
    };
  };
}
