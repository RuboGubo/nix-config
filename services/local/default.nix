{ ... }:
{
  _class = "clan.service";
  manifest.name = "Local Settings";
  manifest.description = "Set the local and input methods, based on context";
  manifest.categories = ["User"];

  roles.server.perInstance.nixosModule.imports = [ ./common.nix ];
  roles.desktop.perInstance.nixosModule.imports = [ ./common.nix ./desktop.nix];
}
