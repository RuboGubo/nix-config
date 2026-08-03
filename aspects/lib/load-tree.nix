{ lib }:
let
  moduleTypes = [
    "nixos"
    "homeManager"
    "darwin"
    "flakeParts"
  ];

  moduleFileNames = builtins.listToAttrs (
    map (moduleType: {
      name = "${moduleType}.nix";
      value = moduleType;
    }) moduleTypes
  );

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

  loadDirectory =
    pathParts: directory:
    let
      entries = builtins.readDir directory;

      childDirectories = lib.filterAttrs (
        name: type: type == "directory" && !(lib.hasPrefix "_" name)
      ) entries;

      children = lib.mapAttrs (
        name: _: loadDirectory (pathParts ++ [ name ]) (directory + "/${name}")
      ) childDirectories;

      fileModules = lib.foldlAttrs (
        result: fileName: moduleType:
        let
          path = directory + "/${fileName}";
        in
        if entries ? ${fileName} && entries.${fileName} == "regular" then
          result // { ${moduleType} = import path; }
        else
          result
      ) { } moduleFileNames;

      modPath = directory + "/mod.nix";
      modValue =
        if builtins.pathExists modPath then
          let
            imported = import modPath;
          in
          if builtins.isFunction imported then
            imported {
              inherit children;
              path = pathParts;
            }
          else
            imported
        else
          { };
    in
    mergeNode (mergeNode children fileModules) modValue;
in
root: loadDirectory [ ] root
