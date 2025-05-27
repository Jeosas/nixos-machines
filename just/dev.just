set working-directory := '..'

# Show this message
@default:
  just --unstable --list dev


# Run a VM with the configuration of the given `host`
vm host:
  rm -f *.qcow2
  nix build .#nixosConfigurations.{{host}}.config.system.build.vm
  nixGL ./result/bin/run-{{host}}-vm -device virtio-vga-gl -display sdl,gl=on -accel kvm

build-iso:
  @echo "Building iso..."
  nixos-rebuild build-image --flake .#iso --image-variant iso-installer

burn-iso drive: build-iso
  @echo "Burning iso to {{drive}}..."
  echo "doas dd if=`ls ./result/iso/nixos-*.iso` of={{drive}} bs=4M status=progress"
  @echo "Done."
  @echo ""

