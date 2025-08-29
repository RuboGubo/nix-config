{
  disko.devices.disk = {
    "main" = {
      # suffix is to prevent disk name collisions
      name = "main-9bc0df8844484814a436bac571ad3f83";
      type = "disk";
      # Set the following in flake.nix for each maschine:
      # device = <uuid>;
      content = {
        type = "gpt";
        partitions = {
          "boot" = {
            size = "1M";
            type = "EF02"; # for grub MBR
            priority = 1;
          };
          "ESP" = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "nofail" ];
            };
          };
          "root" = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              # format = "btrfs";
              # format = "bcachefs";
              mountpoint = "/";
            };
          };
        };
      };
    };
    "swap" = {
      name = "swap-9bc0df8844484814a436bac571ad3f83";
      type = "disk";
      # Set the device in flake.nix or configuration.nix for this disk as well
      # device = <uuid>;
      content = {
        type = "gpt";
        partitions = {
          "swap" = {
            size = "100%";
            content = {
              type = "swap";
            };
          };
        };
      };
    };
  };
}
