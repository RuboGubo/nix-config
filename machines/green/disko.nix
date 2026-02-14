{
  disko.devices.disk = {
    # SSD for system, swap, and subvolume-managed root
    ssd = {
      device = "/dev/sdb"; # <-- replace with your 1TB SSD device
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
            };
          };
          root = {
            size = "100%"; # Root btrfs partition with subvolumes
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@var" = {
                  mountpoint = "/var";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };

    # HDD for additional data / backups
    hdd = {
      device = "/dev/sda"; # <-- replace with your 128 GB HDD device - this is the wrong way round irl... oops
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          data = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home/rubogubo/data"; # or "/var/backup"
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };
}
