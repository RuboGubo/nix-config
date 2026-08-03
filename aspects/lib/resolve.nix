{ lib }:
let
  moduleTypes = [
    "nixos"
    "homeManager"
    "darwin"
    "flakeParts"
  ];

  metadataNames = [
    "_include"
    "_exclude"
    "_aggregate"
  ];

  resolve =
    tree:
    let
      resolveNode =
        path: node:
        let
          childNames = builtins.filter (name: !(builtins.elem name (moduleTypes ++ metadataNames))) (
            builtins.attrNames node
          );

          children = builtins.listToAttrs (
            map (name: {
              inherit name;
              value = resolveNode (path ++ [ name ]) node.${name};
            }) childNames
          );

          includedNames =
            if node._include == null then
              childNames
            else
              builtins.filter (
                name:
                if builtins.elem name childNames then
                  true
                else
                  throw "aspects: ${lib.concatStringsSep "." path} includes missing child '${name}'"
              ) node._include;

          selectedNames = builtins.filter (name: !(builtins.elem name node._exclude)) includedNames;

          importsFor =
            moduleType:
            lib.optionals node._aggregate (
              map (name: children.${name}.${moduleType}) (
                builtins.filter (name: children.${name} ? ${moduleType}) selectedNames
              )
            )
            ++ lib.optional (node.${moduleType} != null) node.${moduleType};

          resolvedModules = builtins.listToAttrs (
            builtins.concatMap (
              moduleType:
              let
                imports = importsFor moduleType;
              in
              lib.optional (imports != [ ]) {
                name = moduleType;
                value = { inherit imports; };
              }
            ) moduleTypes
          );
        in
        children // resolvedModules;
    in
    resolveNode [ ] tree;
in
resolve
