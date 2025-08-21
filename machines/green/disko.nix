{
  disko.devices = {
    # SSD for system, swap, and subvolume-managed root
    disk = {
      ssd = {
        device = "/dev/sda"; # <-- replace with your 1TB SSD device
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "40G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            btrfs_root = {
              size = "100%FREE";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/"; # top-level mount for all subvolumes
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
                # Define subvolumes
                subvolumes = {
                  root = {
                    mountpoint = "/";
                  };
                  home = {
                    mountpoint = "/home";
                  };
                  nix = {
                    mountpoint = "/nix";
                  };
                  var = {
                    mountpoint = "/var";
                  };
                };
              };
            };
          };
        };
      };
    };

    # HDD for additional data / backups
    disk = {
      hdd = {
        device = "/dev/sdb"; # <-- replace with your 128 GB HDD device
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/mnt/data"; # or "/var/backup"
                mountOptions = [ "defaults" ];
              };
            };
          };
        };
      };
    };
  };
}
