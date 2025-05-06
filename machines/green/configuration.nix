{
   imports = [
     ./hardware-configuration.nix
     # contains your disk format and partitioning configuration.
     ../../modules/disko.nix
     # this file is shared among all machines
     ../../modules/shared.nix
     # enables GNOME desktop (optional)
     ../../modules/gnome.nix
   ];

   # Put your username here for login
   users.users.user.name = "rubogubo";

   # Set this for clan commands that use ssh
   # If you change the hostname, you need to update this line to root@<new-hostname>
   # This only works however if you have avahi running on your admin machine else use IP
   clan.core.networking.targetHost = "root@88.80.188.61";


   # Replace this __CHANGE_ME__ with the result of the lsblk command from step 1. 
   disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x500a0751e4fb0c48";

   # IMPORTANT! Add your SSH key here
   # e.g. > cat ~/.ssh/id_ed25519.pub
   users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdUiRDXTrOKj5wP9Urqlg9Ke3caKaC06lRYzVmF4bpA GitLab" ];

   # ...
}