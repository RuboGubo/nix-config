{
  description = "RuboGubo's Clan";
  inputs = {
    nixpkgs.follows = "clan-core/nixpkgs";
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    clan-core.inputs.flake-parts.follows = "flake-parts";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "clan-core/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "clan-core/nixpkgs";
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
        {
          pkgs,
          self',
          system,
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (final: prev: {
                kakao = import ./kakao.nix { pkgs = final; };
              })
            ];
          };

          packages.kakao = import ./packages/kakao.nix { inherit pkgs; };
          apps.kakao = {
            type = "app";
            program = "${self'.packages.kakao}/bin/kakao";
            meta.description = "The Korean Messaging App Kakao Chat";
          };
        };
    };
}
