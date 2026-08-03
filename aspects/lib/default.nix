{ lib }:
{
  loadTree = import ./load-tree.nix { inherit lib; };
  resolve = import ./resolve.nix { inherit lib; };
}
