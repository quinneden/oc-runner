{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              name = "nixos";
              size = "100%";
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
                };
              };
            };

            # root = {
            #   size = "100%";
            #   content = {
            #     type = "btrfs";
            #     extraArgs = [ "-f" ]; # Override existing partition
            #     # Subvolumes must set a mountpoint in order to be mounted,
            #     # unless their parent is mounted
            #     subvolumes = {
            #       # Subvolume name is different from mountpoint
            #       "/rootfs" = {
            #         mountpoint = "/";
            #       };
            #       # Subvolume name is the same as the mountpoint
            #       "/home" = {
            #         mountOptions = [ "compress=zstd" ];
            #         mountpoint = "/home";
            #       };
            #     };
            #     mountpoint = "/partition-root";
            #   };
            # };
          };
        };
      };
      blk = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            nix-store = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                mountpoint = "/nix";
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
}
