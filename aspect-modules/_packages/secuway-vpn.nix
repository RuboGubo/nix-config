{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openssl,
  cryptopp,
  openvpn,
  coreutils,
}:

buildGoModule {
  pname = "secuway-vpn";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "mrcha033";
    repo = "secuway-vpn";
    rev = "5fca72d0673387b46b7b9e96428dbf9668105c74";
    hash = "sha256-5eK/Hz0YvGVFigEsngRXP8OOxynBuzHI53HnZ2s2+Bw=";
  };

  modRoot = "portable";
  vendorHash = "sha256-dH6r6elR3dKx7owr3bUCZ+zmlSC3TMzObeJEbfgmxJU=";
  subPackages = [ "cmd/secuway" ];

  # Nixpkgs currently uses OpenSSL 3.5; upstream also advertises a 3.6 parameter.
  patches = [ ./secuway-openssl-3.5.patch ];

  buildInputs = [
    openssl
    cryptopp
  ];

  postPatch = ''
    substituteInPlace portable/internal/engine/command_unix.go \
      --replace-fail '"/usr/bin/env"' '"${coreutils}/bin/env"'
  '';

  postBuild = ''
    $CXX -std=c++17 -O2 -shared -fPIC \
      -I${lib.getDev cryptopp}/include/cryptopp \
      ../src/lea_provider.cpp -o lea.so -lcryptopp -lcrypto
    $CC ../tests/provider_smoke.c -o provider-smoke -lcrypto
  '';

  postCheck = ''
    OPENSSL_MODULES="$PWD" ./provider-smoke
  '';

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  postInstall = ''
    install -Dm755 lea.so "$out/lib/ossl-modules/lea.so"
    mkdir -p "$out/libexec"
    ln -s ${openvpn}/bin/openvpn "$out/libexec/openvpn"
    ln -s secuway "$out/bin/yonsei-vpn"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/yonsei-vpn" doctor
    runHook postInstallCheck
  '';

  meta = {
    description = "SecuwaySSL-compatible VPN client for Yonsei with an OpenSSL LEA provider";
    homepage = "https://github.com/mrcha033/secuway-vpn";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "yonsei-vpn";
  };
}
