{
  pkgs ? import <nixpkgs> { },
  winearch ? "win32",
  fonts ? "corefonts cjkfonts",
}:

let
  exe = pkgs.fetchurl {
    url = "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe";
    sha256 = "sha256-EEePn6PZPUqc4w9KojHEw9aI+s4WifKdKyYZHhweiMU=";
  };
in

with pkgs;

stdenv.mkDerivation {
  name = "kakaotalk";
  src = ./.;
  buildInputs = [
    pkgs.wineWowPackages.full
    pkgs.winetricks
    pkgs.makeWrapper
  ];
  installPhase = ''
        mkdir -p $out/bin
        cat > $out/bin/kakao <<'EOF'
    #!/usr/bin/env bash
    set -e
    export PATH="${pkgs.wineWowPackages.full}/bin:${pkgs.winetricks}/bin:$PATH"
    PREFIX="$HOME/.kakao-wine"
    if [[ ! -d "$PREFIX/drive_c/Program Files/Kakao/KakaoTalk" ]]; then
      echo "First run: installing fonts and KakaoTalk..."
      if [[ -n "${fonts}" ]]; then
        WINEPREFIX="$PREFIX" WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=${winearch} ${pkgs.winetricks}/bin/winetricks ${fonts}
      fi
      WINEPREFIX="$PREFIX" WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=${winearch} ${pkgs.wineWowPackages.full}/bin/wine ${exe}
    fi
    echo "Launching KakaoTalk..."
    WINEPREFIX="$PREFIX" WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=${winearch} ${pkgs.wineWowPackages.full}/bin/wine "$PREFIX/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe"
    EOF
        chmod +x $out/bin/kakao
  '';
}
