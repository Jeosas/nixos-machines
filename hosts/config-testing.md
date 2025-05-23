# Config testing

Most of the configs are deployed using `nixos-anywhere`, leveraging `disko` for drive formatting.

In order to test that drives are set up correctly and the machine is accessible as expected,
and in order to debug issues and test services, I use Qemu VMs.

Here is how to test configs in VMs.

> INFO: commands below assume your are currently in the default nix shell. If not, run `nix develop`

## Creating drives

Create as much drives as necessary using:

```
for i in {1..6}; do qemu-img create -f qcow2 "drive${i}.qcow2" 16G; done
```

## Create the iso

```
just dev build-iso
```

## Run the VM

Add as much drives as necessary:

```
qemu-system-x86_64 -m 4096 -smp 2 -boot d -cdrom ./result/iso/nixos-*.iso \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd \
  -drive file=drive1.qcow2,format=qcow2,if=virtio \
  -drive file=drive2.qcow2,format=qcow2,if=virtio \
  -drive file=drive3.qcow2,format=qcow2,if=virtio \
  -drive file=drive4.qcow2,format=qcow2,if=virtio \
  -drive file=drive5.qcow2,format=qcow2,if=virtio \
  -drive file=drive6.qcow2,format=qcow2,if=virtio \
  -net nic -net user,hostfwd=tcp::2222-:22 \
  -nographic
```

## Connect to the VM

```
ssh -p 2222 nixos@localhost
```
