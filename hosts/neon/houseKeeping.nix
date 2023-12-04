{ pkgs }:

pkgs.writeShellApplication {
  name = "onegaishimazu";
  runtimeInputs = [ pkgs.bash ];
  text = /* bash */ ''
    #!${pkgs.bash}/bin/bash

    print_help() {
        printf "switch\t\tnixos generation switch\n"
        printf "test\t\tnixos generation test\n"
    }

    cmd=$1
    shift

    case $cmd in
    --help)
        print_help
        exit 0
        ;;
    test)  # Example with an operand
        doas nixos-rebuild test --flake ~/.setup#neon
        exit 0
        ;;
    switch)  # Example with an operand
        doas nixos-rebuild switch --flake ~/.setup#neon
        exit 0
        ;;
    *)
      print_help
      exit 0
      ;;
    esac
  '';
}
