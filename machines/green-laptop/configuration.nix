{ pkgs, ... }:
{
  imports = [
    ./disko.nix
  ];

  nixpkgs.config.allowUnfree = true;
  disko.devices.disk.main.device = "/dev/nvme0n1";
  networking.networkmanager.enable = true;

  networking.useNetworkd = false; # Need this to fix a very random bug.
  boot.loader.systemd-boot.configurationLimit = 2;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Use the Goodix driver module for Dell/Goodix hardware
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  clan.core.settings.state-version.enable = true;
}
