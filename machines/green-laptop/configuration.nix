{
  imports = [
    ../../modules/shared.nix
    ../disko.nix
  ];
  disko.devices.disk.main.device = "/dev/nvme0n1";
}
