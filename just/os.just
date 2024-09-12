alias s := switch
alias t := test
alias u := update


# Show this message
@default:
  just --unstable --list os


# Garbage collect system store
gc: && switch
  doas nix-collect-garbage -d --delete-older-than 7d


# Switch to the new configuration
switch:
  doas nixos-rebuild switch --flake .


# Test new configuration
test *args:
  doas nixos-rebuild test --flake . {{args}}


# Update flake dependencies and switch to new configuration
update: && switch
  nix flake update
