{ lib }:
let
  loadTree = import ./load-tree.nix { inherit lib; };
  resolve = import ./resolve.nix { inherit lib; };
in
{
  inherit loadTree resolve;

  mkTree =
    root:
    let
      tree = loadTree root;
      resolved = resolve tree;
    in
    {
      imports = lib.optional (resolved ? flakeParts) resolved.flakeParts;
      aspects = tree;
    };
}
