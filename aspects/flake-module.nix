{ aspectsLib }:
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  nodeType = types.submodule {
    freeformType = types.lazyAttrsOf nodeType;

    options = {
      nixos = mkOption {
        type = types.nullOr types.deferredModule;
        default = null;
        description = "NixOS module owned by this aspect.";
      };

      homeManager = mkOption {
        type = types.nullOr types.deferredModule;
        default = null;
        description = "Home Manager module owned by this aspect.";
      };

      darwin = mkOption {
        type = types.nullOr types.deferredModule;
        default = null;
        description = "nix-darwin module owned by this aspect.";
      };

      flakeParts = mkOption {
        type = types.nullOr types.deferredModule;
        default = null;
        description = "flake-parts module owned by this aspect.";
      };

      _include = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Immediate child aspects included in automatic aggregation.";
      };

      _exclude = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Immediate child aspects excluded from automatic aggregation.";
      };

      _aggregate = mkOption {
        type = types.bool;
        default = true;
        description = "Whether this aspect imports modules from selected child aspects.";
      };
    };
  };
in
{
  options.aspects = mkOption {
    type = nodeType;
    default = { };
    description = "An arbitrarily nested tree of typed module aspects.";
  };

  config.flake.aspects = aspectsLib.resolve config.aspects;
}
