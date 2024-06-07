vm host:
  rm -f *.qcow2
  nix build .#nixosConfigurations.{{host}}.config.system.build.vm
  nixGL ./result/bin/run-{{host}}-vm -device virtio-vga-gl -display sdl,gl=on -accel kvm

deploy host:
  nixos-rebuild switch --flake .#{{host}} --target-host root@{{host}} 

update-apps:
  nix flake lock --update-input thewinterdev-website
