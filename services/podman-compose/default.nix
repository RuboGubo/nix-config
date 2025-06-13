{ ... }:
{
  _class = "clan.service";
  manifest.name = "Docker Compose";
  manifest.description = "Run docker compose files";
  manifest.categories = ["User"];

  roles.default = {
    interface = { lib, ... }: {
      options.path = lib.mkOption {
        type = lib.types.path;
        description = "The path in your config to the docker-compose file.";
      };
    };

    perInstance = {settings, ...}: { nixosModule = {pkgs, ...}: {imports = [ (import ./common.nix {inherit settings pkgs;}) ];};};
  };
}
