mod dev './just/dev.just'
mod home './just/home.just'
mod os './just/os.just'

# Show this message
@default:
  just --list

# Deploy a configuration to the given `host`
deploy host:
  nixos-rebuild switch --flake .#{{host}} --target-host root@{{host}} 

# Update apps withcout updating nixpkgs
update-apps:
  nix flake lock --update-input thewinterdev-website
