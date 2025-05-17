# Show this message
@default:
  just --unstable --list dev


# Run a VM with the configuration of the given `host`
vm host:
  rm -f *.qcow2
  nix build .#nixosConfigurations.{{host}}.config.system.build.vm
  nixGL ./result/bin/run-{{host}}-vm -device virtio-vga-gl -display sdl,gl=on -accel kvm

burn-iso drive:
  @echo "Building iso..."
  nix build .#nixosConfigurations.iso.config.system.build.images.iso
  @echo "Burning iso to {{drive}}..."
  doas dd if=../result/iso/nixos-*.iso of={{drive}} bs=4M status=progress
  @echo "Done."
  @echo ""

