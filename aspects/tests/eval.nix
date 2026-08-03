{
  aspectsLib,
  flake-parts,
  lib,
}:
let
  rawTree = aspectsLib.loadTree ./tree;

  result = flake-parts.lib.mkFlake { inputs = { }; } {
    imports = [ (import ../flake-module.nix { inherit aspectsLib; }) ];
    aspects = rawTree;
  };

  evaluated = lib.evalModules {
    specialArgs = { self = result; };
    modules = [
      result.aspects.rubogubo.desktop.nixos
      {
        options.test.genericSteam = lib.mkEnableOption "generic Steam test marker";
        options.test.customSteam = lib.mkEnableOption "custom Steam test marker";
      }
    ];
  };
in
assert evaluated.config.test.genericSteam;
assert evaluated.config.test.customSteam;
{
  inherit rawTree;
  resolvedTree = result.aspects;
}
