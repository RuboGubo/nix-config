{ lib }:
let
  moduleTypes = [
    "nixos"
    "home"
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
      # Apply the resolved tree directly to function-valued modules. Using
      # `_module.args` here would be too late: the module system resolves a
      # function's `imports` before evaluating `_module.args` from config.
      withAspects =
        module:
        if builtins.isFunction module then
          lib.setFunctionArgs
            (args: module (args // { aspects = resolved; }))
            (builtins.removeAttrs (builtins.functionArgs module) [ "aspects" ])
        else if builtins.isAttrs module && module ? imports then
          module // { imports = map withAspects module.imports; }
        else
          module;

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
            if (node._include or null) == null then
              childNames
            else
              builtins.filter (
                name:
                if builtins.elem name childNames then
                  true
                else
                  throw "aspects: ${lib.concatStringsSep "." path} includes missing child '${name}'"
              ) node._include;

          selectedNames = builtins.filter (name: !(builtins.elem name (node._exclude or [ ]))) includedNames;

          importsFor =
            moduleType:
            lib.optionals (node._aggregate or true) (
              map (name: children.${name}.${moduleType}) (
                builtins.filter (name: children.${name} ? ${moduleType}) selectedNames
              )
            )
            ++ lib.optional ((node.${moduleType} or null) != null) node.${moduleType};

          resolvedModules = builtins.listToAttrs (
            builtins.concatMap (
              moduleType:
              let
                imports = importsFor moduleType;
              in
              lib.optional (imports != [ ]) {
                name = moduleType;
                value.imports = map withAspects imports;
              }
            ) moduleTypes
          );
        in
        children // resolvedModules;
      resolved = resolveNode [ ] tree;
    in
    resolved;
in
resolve
