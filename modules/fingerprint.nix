{
  flake.modules.nixos.fingerprint = {pkgs, ...}: {
    services.fprintd.enable = true;
  };
}
