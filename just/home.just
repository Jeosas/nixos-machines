alias s := switch
alias u := update


# Show this message
@default:
  just --unstable --list home


# Garbage collect system store
gc: && switch
  nix-collect-garbage -d --delete-older-than 7d;

# Switch to the new configuration
switch:
  home-manager switch --flake .


# Update flake dependencies and switch to new configuration
update: && switch
  nix flake update
