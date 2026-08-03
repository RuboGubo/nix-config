{
  description = "Arbitrarily nested, composable module aspects for flake-parts";

  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs-lib.follows = "flake-parts/nixpkgs-lib";

  outputs =
    {
      self,
      flake-parts,
      nixpkgs-lib,
    }:
    {
      lib = import ./lib { lib = nixpkgs-lib.lib; };
      flakeModules.default = import ./flake-module.nix { aspectsLib = self.lib; };

      tests = builtins.deepSeq (import ./tests/eval.nix {
        aspectsLib = self.lib;
        inherit flake-parts;
        lib = nixpkgs-lib.lib;
      }) true;
    };
}
