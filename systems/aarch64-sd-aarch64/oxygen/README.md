# Oxygen

> Hardware: rpi 3b+

## Create sd-image

> TODO: change me

```console
$ nix build .#images.oxygen
```

## Flash sd-card

> Check sd-card location with `lsblk`

```console
# dd if=./result/sd-image/nixos*-aarch64-linux.img of=/dev/sdX bs=4096 conv=fsync status=progress
```
