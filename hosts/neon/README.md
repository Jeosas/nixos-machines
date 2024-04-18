# Neon

> Hardware: Custom (i7 g10, 32Gb, RTX3080)

## Install

### Setup install shell

```console
$ nix-shell -p git
```

### Clone repo

```console
$ git clone https://github.com/Jeosas/nixos-machines
$ cd nixos-machines
```

### Format disks and generate hardware-configuration.nix

```console
$ sudo bash ./hosts/neon/bootstrap
```

### (optional) Setup new `hardware.nix` file

> `hardware.nix` should already be good to go, only copy if there are hardware changes.

#### Add impermanence setup

Add the `neededForBoot = true;` attribute to all devices except `/boot`.

#### Copy new hardware.nix

```console
$ cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/neon/hardware.nix
$ git add ./hosts/neon/hardware.nix
```

### Setup user password

```console
$ sudo bash -c 'mkpasswd -m sha-512 > /persist/jeosas-password'
```

### Install NixOS

```console
$ sudo nixos-install --flake .#neon --no-root-passwd
```

### Copy config to new system

```console
$ cd ~
$ cp -R nixos-machines/. /mnt/persist/home/jeosas/.setup/
```

### Reboot

```console
$ sudo reboot
```

CONGRATULATIONS ! Your system is up and running :rocket:

