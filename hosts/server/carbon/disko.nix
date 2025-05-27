{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  config = {
    disko.devices = {
      disk =
        let
          mkBoot = id: device: pool: {
            type = "disk";
            inherit device;
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot${builtins.toString id}";
                    mountOptions = [ "nofail" ];
                  };
                };
                zfs = {
                  size = "100%";
                  content = {
                    type = "zfs";
                    pool = "zboot";
                  };
                };
              };
            };
            # For vm testing
            imageSize = "16G";
          };

          mkColdStorage = device: pool: {
            type = "disk";
            inherit device;
            content = {
              type = "gpt";
              partitions = {
                zfs = {
                  size = "100%";
                  content = {
                    type = "zfs";
                    pool = "zcoldstorage";
                  };
                };
              };
            };
            # For vm testing
            imageSize = "16G";
          };
        in
        {
          # Boot drives
          boot = mkBoot 1 "/dev/vda" "zboot";
          boot_mirror = mkBoot 2 "/dev/vdb" "zboot";

          # Cold storage drives
          cold_storage_1 = mkColdStorage "/dev/vdc" "zcoldstorage";
          cold_storage_1_mirror = mkColdStorage "/dev/vdd" "zcoldstorage";
          cold_storage_2 = mkColdStorage "/dev/vde" "zcoldstorage";
          cold_storage_2_mirror = mkColdStorage "/dev/vdf" "zcoldstorage";

        };

      # ZFS pools
      zpool = {
        zboot = {
          type = "zpool";
          mode = "mirror";
          rootFsOptions = {
            compression = "zstd";
            acltype = "posixacl";
            dnodesize = "auto";
            canmount = "off";
            xattr = "sa";
            relatime = "on";
            normalization = "formD";
            mountpoint = "none";
            # encryption = "aes-256-gcm";
            # keyformat = "passphrase";
            # keylocation = "file:///tmp/enc.key";
            "com.sun:auto-snapshot" = "false";
          };
          options = {
            ashift = "12";
            autotrim = "on";
          };

          datasets = {
            local = {
              # never backed up
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            safe = {
              # can be backed up
              type = "zfs_fs";
              options.mountpoint = "none";
            };

            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
              options.mountpoint = "legacy";
              postCreateHook = ''
                zfs snapshot zboot/local/root@blank
              '';
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options = {
                atime = "off";
                canmount = "on";
                mountpoint = "legacy";
                "com.sun:auto-snapshot" = "false";
              };
            };
            "local/log" = {
              type = "zfs_fs";
              mountpoint = "/var/log";
              options = {
                mountpoint = "legacy";
                "com.sun:auto-snapshot" = "false";
              };
            };
            "safe/persist" = {
              type = "zfs_fs";
              mountpoint = "/persist";
              options = {
                mountpoint = "legacy";
                "com.sun:auto-snapshot" = "false";
              };
            };
          };
        };
        zcoldstorage = {
          type = "zpool";
          mode = {
            topology = {
              type = "topology";
              vdev = [
                {
                  mode = "mirror";
                  members = [
                    "cold_storage_1"
                    "cold_storage_1_mirror"
                  ];
                }
                {
                  mode = "mirror";
                  members = [
                    "cold_storage_2"
                    "cold_storage_2_mirror"
                  ];
                }
              ];
            };
          };

          rootFsOptions = {
            compression = "zstd";
            acltype = "posixacl";
            dnodesize = "auto";
            canmount = "off";
            xattr = "sa";
            relatime = "on";
            normalization = "formD";
            mountpoint = "none";
          };
          options = {
            ashift = "12";
            autotrim = "on";
          };

          datasets = {
            local = {
              # never backed up
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            safe = {
              # can be backed up
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "safe/storage" = {
              type = "zfs_fs";
              # options = {
              #   encryption = "aes-256-gcm";
              #   keyformat = "passphrase";
              #   keylocation = "file:///tmp/enc.key";
              # };
              mountpoint = "/storage";
            };
          };

        };
      };
    };

    boot.loader.grub.mirroredBoots = [
      {
        devices = [ "nodev" ]; # not used in UEFI
        path = "/boot1";
      }
      {
        devices = [ "nodev" ]; # not used in UEFI
        path = "/boot2";
      }
    ];

    fileSystems = {
      "/".neededForBoot = true;
      "/nix".neededForBoot = true;
      "/var/log".neededForBoot = true;
      "/persist".neededForBoot = true;
    };
  };

}
