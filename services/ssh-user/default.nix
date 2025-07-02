{ ... }:
{
  _class = "clan.service";
  manifest.name = "SSH User";
  manifest.description = "A service to set up ssh keys for an individual user";
  manifest.categories = [ "User" ];

  roles."ssh-from" = {
    interface =
      { lib, ... }:
      {
        options.user = lib.mkOption {
          type = lib.types.str;
          description = "The user to install the secret to.";
        };
      };

    perInstance =
      {
        settings,
        pkgs,
        ...
      }:
      {
        nixosModule =
          { config, ... }:
          {
            imports = [ (import ./ssh/from.nix { inherit settings config pkgs; }) ];
          };
      };
  };
  roles."ssh-to" = {
    interface =
      { lib, ... }:
      {
        options.user = lib.mkOption {
          type = lib.types.str;
          description = "The user to install the public key to.";
        };
      };

    perInstance =
      {
        settings,
        pkgs,
        ...
      }:
      {
        nixosModule =
          { config, ... }:
          {
            imports = [ (import ./ssh/to.nix { inherit settings config pkgs; }) ];
          };
      };
  };
}
