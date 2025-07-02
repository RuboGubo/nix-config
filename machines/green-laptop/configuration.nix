{
  imports = [
    ../../modules/shared.nix
    ../../modules/disko.nix
  ];
  clan.core.networking.targetHost = "root@172.16.2.212";

  disko.devices.disk.main.device = "/dev/nvme0n1";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdUiRDXTrOKj5wP9Urqlg9Ke3caKaC06lRYzVmF4bpA GitLab"
  ];
}
