{
  description = "RuboGubo's Clan";
  inputs = {
    nixpkgs.follows = "clan-core/nixpkgs";
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    clan-core.inputs.flake-parts.follows = "flake-parts";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "clan-core/nixpkgs";

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "clan-core/nixpkgs";
    };

    arion.url = "github:hercules-ci/arion";
    arion.inputs.nixpkgs.follows = "clan-core/nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    primes = {
      url = "git+https://gitlab.com/client-projects19/public-projects/primesrust.git";
      inputs.nixpkgs.follows = "clan-core/nixpkgs";
    };

    personal-website = {
      url = "git+ssh://git@gitlab.com/RuboGubo/personal-website.git";
      inputs.nixpkgs.follows = "clan-core/nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    valentines = {
      url = "git+ssh://git@gitlab.com/RuboGubo/valentines.git";
      # inputs.nixpkgs.follows = "clan-core/nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./clan.nix
        ./devshells.nix
        (inputs.import-tree ./modules)
        inputs.flake-parts.flakeModules.modules
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
