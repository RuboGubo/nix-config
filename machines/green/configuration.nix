{lib, ...}: {
  imports = [
    ./disko.nix
  ];
  networking.useNetworkd = true; # Need this to fix a very random bug.
  boot.loader.grub.device = lib.mkDefault "/dev/sda";
  
  clan.core.settings.state-version.enable = true;
}
