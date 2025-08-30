{
  clan.modules."green_siren_services" = import ./default.nix;

  perSystem =
    { pkgs, ... }:
    {
      packages.nginx-container = import ./nginx/container.nix { inherit pkgs; };
    };
}
