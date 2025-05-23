#!/usr/bin/env bash

set -euxo pipefail

# Build disko image builder
nix build .#nixosConfigurations.carbon.config.system.build.diskoImagesScript

# Testing zfs encryption passphrase
echo "asdfasdfasdf" >enc.key

# Build images
./result --pre-format-files "$(pwd)/enc.key" /tmp/enc.key --build-memory 4096

just dev build-iso

# Run VM
qemu-system-x86_64 -m 4096 -smp 2 -boot d -cdrom ./result/iso/nixos-*.iso \
  -drive format=raw,if=virtio,file=boot.raw \
  -drive format=raw,if=virtio,file=boot_mirror.raw \
  -drive format=raw,if=virtio,file=cold_storage_1.raw \
  -drive format=raw,if=virtio,file=cold_storage_1_mirror.raw \
  -drive format=raw,if=virtio,file=cold_storage_2.raw \
  -drive format=raw,if=virtio,file=cold_storage_2_mirror.raw \
  -net nic -net user,hostfwd=tcp::2222-:22
# -nographic
