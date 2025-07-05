{
  description = "RuboGubo's Clan";
  inputs = {
    nixpkgs.follows = "clan-core/nixpkgs";
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    clan-core.inputs.flake-parts.follows = "flake-parts";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./clan.nix
        ./devshells.nix
      ];
      systems = [
        "x86_64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
