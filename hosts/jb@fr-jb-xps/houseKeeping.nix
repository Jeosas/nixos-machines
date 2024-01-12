{ pkgs }:

pkgs.writeShellApplication {
  name = "onegaishimasu";
  runtimeInputs = [ pkgs.bash ];
  text = /* bash */ ''
    #!${pkgs.bash}/bin/bash

    print_help() {
        printf "switch\t\thome-manager generation switch\n"
        printf "update\t\tsystem update\n"
    }

    hm_switch() {
        home-manager switch --flake ~/.setup
    }

    cmd=$1
    shift

    case $cmd in
    --help)
        print_help
        exit 0
        ;;
    switch)  # Example with an operand
        hm_switch
        exit 0
        ;;
    update)
        sudo apt update && sudo apt upgrade
        cd ~/.setup && nix flake update && hm_switch
        exit 0
        ;;
    *)
      print_help
      exit 0
      ;;
    esac
  '';
}
