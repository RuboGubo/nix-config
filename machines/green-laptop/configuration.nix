{ ... }:
{
  imports = [
    ./disko.nix
  ];

  nixpkgs.config.allowUnfree = true;
  disko.devices.disk.main.device = "/dev/nvme0n1";
  networking.networkmanager.enable = true;
  networking.useNetworkd = false;
  
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024; # 16 GB
  }];

  clan.core.settings.state-version.enable = true;
}
