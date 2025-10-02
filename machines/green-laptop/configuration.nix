{
  imports = [
    ../../modules/shared.nix
    ./disko.nix
  ];

  nixpkgs.config.allowUnfree = true;
  disko.devices.disk.main.device = "/dev/nvme0n1";
  networking.useNetworkd = true; # Need this to fix a very random bug.

  clan.core.settings.state-version.enable = true;
}
