{ ... }:
{
  imports = [
    ./disko.nix
  ];

  nixpkgs.config.allowUnfree = true;
  disko.devices.disk.main.device = "/dev/nvme0n1";
  networking.networkmanager.enable = true;

  networking.useNetworkd = false; # Need this to fix a very random bug.
  boot.loader.systemd-boot.configurationLimit = 2;

  
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024; # 16 GB
  }];

  clan.core.settings.state-version.enable = true;
}
