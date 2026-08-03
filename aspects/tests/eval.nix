{
  aspectsLib,
  flake-parts,
  lib,
}:
let
  # Directory discovery is the foundation for the filesystem-facing API. The
  # fixture includes normal directories, dotted directories, dotted files,
  # mod.nix files, ignored paths, and every supported module endpoint type.
  rawTree = aspectsLib.loadTree ./tree;

  result = flake-parts.lib.mkFlake { inputs = { }; } {
    imports = [ (import ../flake-module.nix { inherit aspectsLib; }) ];
    aspects = rawTree;
  };

  # Covers arbitrary namespace nesting, parent aggregation, and composition
  # through an ordinary `imports = [ self.aspects.steam.nixos ];` declaration.
  steamEvaluation = lib.evalModules {
    specialArgs = { self = result; };
    modules = [
      result.aspects.rubogubo.desktop.nixos
      {
        options.test.genericSteam = lib.mkEnableOption "generic Steam test marker";
        options.test.customSteam = lib.mkEnableOption "custom Steam test marker";
      }
    ];
  };

  # Verifies that `common/nixos.nix` and `common.nixos.nix` produce equivalent
  # paths. The merged fixture also ensures both forms compose when they target
  # the same path instead of silently replacing one another.
  formsEvaluation = lib.evalModules {
    modules = [
      result.aspects.forms.folder.common.nixos
      result.aspects.forms.file.common.nixos
      result.aspects.forms.merged.common.nixos
      {
        options.test.folderForm = lib.mkEnableOption "directory/module-type file form";
        options.test.fileForm = lib.mkEnableOption "dotted module-type file form";
        options.test.mergedFolderForm = lib.mkEnableOption "merged directory form";
        options.test.mergedFileForm = lib.mkEnableOption "merged dotted file form";
      }
    ];
  };

  # Exercises the three automatic aggregation controls: _include acts as an
  # allowlist, _exclude removes selected children, and _aggregate = false keeps
  # the node's own module while preventing child imports.
  controlsEvaluation = lib.evalModules {
    modules = [
      result.aspects.controls.include.nixos
      result.aspects.controls.exclude.nixos
      result.aspects.controls.disabled.nixos
      {
        options.test.included = lib.mkEnableOption "included child";
        options.test.omitted = lib.mkEnableOption "child omitted by _include";
        options.test.excludeIncluded = lib.mkEnableOption "child retained by _exclude";
        options.test.excluded = lib.mkEnableOption "child removed by _exclude";
        options.test.aggregateOwner = lib.mkEnableOption "module owned by non-aggregating node";
        options.test.aggregateChild = lib.mkEnableOption "child of non-aggregating node";
      }
    ];
  };

  # The Steam fixture uses a plain mod.nix. This fixture covers function-valued
  # mod.nix and verifies that it receives both the logical dotted path and
  # children discovered from dotted files.
  functionModEvaluation = lib.evalModules {
    modules = [
      result.aspects.function-mod.nixos
      {
        options.test.functionMod = lib.mkEnableOption "function mod metadata";
        options.test.functionModChild = lib.mkEnableOption "function mod child";
      }
    ];
  };

  # NixOS, Home Manager, and nix-darwin endpoints are all deferred modules and
  # should be independently consumable by the standard Nix module evaluator.
  typedModulesEvaluation = lib.evalModules {
    modules = [
      result.aspects.types.nixos
      result.aspects.types.homeManager
      result.aspects.types.darwin
      {
        options.test.nixosType = lib.mkEnableOption "NixOS endpoint";
        options.test.homeManagerType = lib.mkEnableOption "Home Manager endpoint";
        options.test.darwinType = lib.mkEnableOption "darwin endpoint";
      }
    ];
  };

  # flakeParts is the fourth supported endpoint and must be consumable directly
  # by flake-parts.
  typedFlakePartsResult = flake-parts.lib.mkFlake { inputs = { }; } {
    imports = [ result.aspects.types.flakeParts ];
  };

  # Besides filesystem discovery, the flake-parts option accepts explicit
  # definitions at arbitrary depth.
  explicitResult = flake-parts.lib.mkFlake { inputs = { }; } {
    imports = [ (import ../flake-module.nix { inherit aspectsLib; }) ];
    aspects.explicit.arbitrarily.deep.nixos = {
      test.explicitDefinition = true;
    };
  };

  explicitEvaluation = lib.evalModules {
    modules = [
      explicitResult.aspects.explicit.nixos
      {
        options.test.explicitDefinition = lib.mkEnableOption "explicit deep definition";
      }
    ];
  };

  # mkTree combines loadTree with automatic importing of the tree's aggregated
  # flakeParts endpoint.
  mkTreeResult = flake-parts.lib.mkFlake { inputs = { }; } {
    imports = [
      (import ../flake-module.nix { inherit aspectsLib; })
      (aspectsLib.mkTree ./mk-tree)
    ];
  };

  # Invalid dotted paths are forced deeply because discovery is intentionally
  # lazy. Empty, reserved module-type, and underscore-prefixed namespace
  # components must all be rejected.
  invalidEmpty = builtins.tryEval (builtins.deepSeq (aspectsLib.loadTree ./invalid/empty) true);
  invalidReserved = builtins.tryEval (builtins.deepSeq (aspectsLib.loadTree ./invalid/reserved) true);
  invalidPrivate = builtins.tryEval (builtins.deepSeq (aspectsLib.loadTree ./invalid/private) true);
in
assert steamEvaluation.config.test.genericSteam;
assert steamEvaluation.config.test.customSteam;
assert formsEvaluation.config.test.folderForm;
assert formsEvaluation.config.test.fileForm;
assert formsEvaluation.config.test.mergedFolderForm;
assert formsEvaluation.config.test.mergedFileForm;
assert controlsEvaluation.config.test.included;
assert !controlsEvaluation.config.test.omitted;
assert controlsEvaluation.config.test.excludeIncluded;
assert !controlsEvaluation.config.test.excluded;
assert controlsEvaluation.config.test.aggregateOwner;
assert !controlsEvaluation.config.test.aggregateChild;
assert functionModEvaluation.config.test.functionMod;
assert functionModEvaluation.config.test.functionModChild;
assert typedModulesEvaluation.config.test.nixosType;
assert typedModulesEvaluation.config.test.homeManagerType;
assert typedModulesEvaluation.config.test.darwinType;
assert typedFlakePartsResult.testFlakePartsType;
assert explicitEvaluation.config.test.explicitDefinition;
assert mkTreeResult.mkTreeImported;
assert mkTreeResult.aspects ? flakeParts;
# Underscore-prefixed files and directories are ignored during discovery.
assert result.aspects.ignored == { };
assert !invalidEmpty.success;
assert !invalidReserved.success;
assert !invalidPrivate.success;
{
  inherit rawTree;
  resolvedTree = result.aspects;
}
