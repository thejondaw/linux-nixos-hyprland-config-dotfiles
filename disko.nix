{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            swap = {
              name = "swap";
              size = "16G";
              content = {
                type = "swap";
              };
            };

            luks = {
              name = "cryptroot";
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  pbkdf = "argon2id";
                  iterations = 4;
                  memoryKiB = 131072;
                };
                passwordFile = "/tmp/secret.key";
                
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                        "space_cache=v2"
                        "ssd_spread"
                        "discard=async"
                        "commit=120"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                        "space_cache=v2"
                        "ssd_spread"
                        "discard=async"
                      ];
                    };
                    "@var" = {
                      mountpoint = "/var";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime" 
                        "space_cache=v2"
                        "ssd_spread"
                        "discard=async"
                      ];
                    };
                    "@varlog" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                        "space_cache=v2"
                        "ssd_spread"
                        "discard=async"  
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                        "space_cache=v2"
                        "ssd_spread"
                        "discard=async"
                      ];
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                        "space_cache=v2"
                        "ssd_spread"
                        "discard=async"
                      ];
                    };
                    "@cache" = {
                      mountpoint = "/var/cache";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                        "space_cache=v2"
                        "ssd_spread"
                        "discard=async"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
