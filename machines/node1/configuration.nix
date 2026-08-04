{ inputs, ... }:
{
  imports = [
    ./linode.nix
    inputs.self.aspects.machines.node1.nixos
  ];
  # Replace this __CHANGE_ME__ with the result of the lsblk command from step 1.
  disko.devices.disk.main.device = "/dev/sda";
  disko.devices.disk.swap.device = "/dev/sdb";

  clan.core.settings.state-version.enable = true;
}
