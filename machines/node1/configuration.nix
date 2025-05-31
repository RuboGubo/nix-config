{
   imports = [
     # ./hardware-configuration.nix
     # contains your disk format and partitioning configuration.
     ../../modules/disko_linode.nix
     # this file is shared among all machines
     ../../modules/shared.nix
     # enables GNOME desktop (optional)
    #  ../../modules/gnome.nix
   ];
   clan.core.networking.targetHost = "root@88.80.188.61";
   
   # Replace this __CHANGE_ME__ with the result of the lsblk command from step 1.
   disko.devices.disk.main.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi-disk-0";
   disko.devices.disk.swap.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi-disk-1";

   # IMPORTANT! Add your SSH key here
   # e.g. > cat ~/.ssh/id_ed25519.pub
   users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdUiRDXTrOKj5wP9Urqlg9Ke3caKaC06lRYzVmF4bpA GitLab" ];
}
