{ ... }:
{
  _class = "clan.service";
  manifest.name = "SSH User";
  manifest.description = "A service to set up ssh keys for an individual user";
  manifest.categories = [ "User" ];

  roles."ssh.from" = import ./ssh/from.nix;
  roles."ssh.to".perInstance.nixosModule.imports = [ ./ssh/to.nix ];
}
