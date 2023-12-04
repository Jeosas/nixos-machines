switch host:
  home-manager switch --flake .#{{host}}

vm host:
  nix build .#nixosConfigurations.{{host}}.config.system.build.vm
  ./result/bin/run-{{host}}-vm
  rm -f *.qcow2
