{ lib }:
let
  moduleTypes = [
    "nixos"
    "home"
    "darwin"
    "flakeParts"
  ];

  mergeModule = left: right: {
    imports = [
      left
      right
    ];
  };

  mergeNode =
    left: right:
    lib.foldlAttrs (
      result: name: value:
      result
      // {
        ${name} =
          if result ? ${name} && builtins.elem name moduleTypes then
            mergeModule result.${name} value
          else if result ? ${name} && builtins.isAttrs result.${name} && builtins.isAttrs value then
            mergeNode result.${name} value
          else
            value;
      }
    ) left right;

  parseNamespace = source: name:
    let
      parts = lib.splitString "." name;
      invalidPart = builtins.any (
        part: part == "" || builtins.elem part moduleTypes || lib.hasPrefix "_" part
      ) parts;
    in
    if invalidPart then
      throw "aspects: invalid dotted namespace '${name}' at ${toString source}"
    else
      parts;

  insertAtPath = tree: path: value: mergeNode tree (lib.setAttrByPath path value);

  loadDirectory =
    pathParts: directory:
    let
      entries = builtins.readDir directory;

      children = lib.foldlAttrs (
        result: name: type:
        if type == "directory" && !(lib.hasPrefix "_" name) then
          let
            namespace = parseNamespace directory name;
            child = loadDirectory (pathParts ++ namespace) (directory + "/${name}");
          in
          insertAtPath result namespace child
        else
          result
      ) { } entries;

      fileModules = lib.foldlAttrs (
        result: fileName: type:
        let
          isCandidate =
            type == "regular"
            && fileName != "mod.nix"
            && !(lib.hasPrefix "_" fileName)
            && lib.hasSuffix ".nix" fileName;
          stem = lib.removeSuffix ".nix" fileName;
          parts = lib.splitString "." stem;
          moduleType = if parts == [ ] then null else lib.last parts;
          namespace = if parts == [ ] then [ ] else lib.init parts;
          validNamespace = !(builtins.any (
            part: part == "" || builtins.elem part moduleTypes || lib.hasPrefix "_" part
          ) namespace);
        in
        if isCandidate && builtins.elem moduleType moduleTypes then
          if validNamespace then
            insertAtPath result (namespace ++ [ moduleType ]) (import (directory + "/${fileName}"))
          else
            throw "aspects: invalid dotted module path '${fileName}' at ${toString directory}"
        else
          result
      ) { } entries;

      discovered = mergeNode children fileModules;

      modPath = directory + "/mod.nix";
      modValue =
        if builtins.pathExists modPath then
          let
            imported = import modPath;
          in
          if builtins.isFunction imported then
            imported {
              children = discovered;
              path = pathParts;
            }
          else
            imported
        else
          { };
    in
    mergeNode discovered modValue;
in
root: loadDirectory [ ] root
