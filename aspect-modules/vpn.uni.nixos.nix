{ pkgs, ... }:
let
  secuway = pkgs.callPackage ./_packages/secuway-vpn.nix { };
  openvpnWithLea = pkgs.symlinkJoin {
    name = "openvpn-with-lea";
    paths = [ pkgs.openvpn ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/openvpn" \
        --set OPENSSL_MODULES ${secuway}/lib/ossl-modules \
        --add-flags "--providers lea default --disable-dco"
    '';
  };
in
{
  networking.networkmanager.plugins = [
    (pkgs.networkmanager-openvpn.override { openvpn = openvpnWithLea; })
  ];
}
