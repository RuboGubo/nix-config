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
in
assert steamEvaluation.config.test.genericSteam;
assert steamEvaluation.config.test.customSteam;
assert formsEvaluation.config.test.folderForm;
assert formsEvaluation.config.test.fileForm;
assert formsEvaluation.config.test.mergedFolderForm;
assert formsEvaluation.config.test.mergedFileForm;
{
  inherit rawTree;
  resolvedTree = result.aspects;
}
