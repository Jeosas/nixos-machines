{ pkgs }:

with pkgs;
writeShellApplication {
  name = "onegaishimasu";
  text = /* bash */ ''
    #!/bin/bash

    print_help() {
        printf "diff\t\tlist ephemeral files lost on next reboot\n"
        printf "switch\t\tnixos generation switch\n"
        printf "test\t\tnixos generation test\n"
        printf "update\t\tsystem update\n"
    }

    nixos_switch() {
        doas nixos-rebuild switch --flake ~/.setup
    }

    cmd=$1
    shift

    case $cmd in
    --help)
        print_help
        exit 0
        ;;
    diff)
        tree -x /
        exit 0
        ;;
    test)  # Example with an operand
        doas nixos-rebuild test --flake ~/.setup
        exit 0
        ;;
    switch)  # Example with an operand
        nixos_switch
        exit 0
        ;;
    update)
        cd ~/.setup && nix flake update && nixos_switch
        exit 0
        ;;
    *)
      echo "Unknown command."
      echo ""
      print_help
      exit 0
      ;;
    esac
  '';
}
