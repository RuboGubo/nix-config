{ pkgs, ... }:
{
  home.packages = [
    pkgs.openfortivpn
    (pkgs.callPackage ./_packages/secuway-vpn.nix { })
  ];
}
