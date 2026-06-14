current_user := env('USER')
home_dir := env('HOME')

alias s := stow


# Show this message
@default:
  just --unstable --list home

# Run GNU stow for user (default: current)
stow user=current_user:
  @systemctl --user start stow-nix-{{user}}.service && echo "ok"
