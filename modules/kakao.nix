{
  pkgs ? import <nixpkgs> { },
  wineprefix ? "",
  winearch ? "win32",
  fonts ? "corefonts cjkfonts",
}:

let
  exe = pkgs.fetchurl {
    url = "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe";
    sha256 = "1wy358vwj4l6j7kkinq8rmrspj6pb34b8vsazq2pnbm9qrxymckj";
  };
in

with pkgs;

stdenv.mkDerivation {
  name = "kakaotalk";
  src = ./.;
  buildInputs = [
    wineWowPackages.full
    winetricks
  ];
  shellHook = ''
    PREFIX=${wineprefix}
    if [[ -z "${wineprefix}" ]]; then
      PREFIX=$(mktemp -d)
      echo PREFIX="$PREFIX"
    fi
    echo Install kakaotalk from ${exe}...
    if [[ -z "${fonts}" ]]; then
      echo Skip winetricks
    else
      WINEPREFIX=$PREFIX WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=${winearch} winetricks ${fonts}
    fi
    WINEPREFIX=$PREFIX WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=${winearch} wine ${exe}
  '';
}
