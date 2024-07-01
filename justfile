# Show this message
@default:
  just --list

# Run a VM with the configuration of the given `host`
vm host:
  rm -f *.qcow2
  nix build .#nixosConfigurations.{{host}}.config.system.build.vm
  nixGL ./result/bin/run-{{host}}-vm -device virtio-vga-gl -display sdl,gl=on -accel kvm

# Deploy a configuration to the given `host`
deploy host:
  nixos-rebuild switch --flake .#{{host}} --target-host root@{{host}} 

# Update apps withcout updating nixpkgs
update-apps:
  nix flake lock --update-input thewinterdev-website

alias t := test

# Test new configuration
test:
  doas nixos-rebuild test --flake .

alias s := switch

# Stitch to the new configuration
switch:
  doas nixos-rebuild switch --flake .

alias u := update

# Update flake dependencies and switch to new configuration
update: && switch
  nix flake update

# Garbage collect system store
gc: && switch
  doas nix-collect-garbage -d --delete-older-than 7d
