{pkgs}: let
  onegaishimasu = pkgs.writeShellApplication {
    name = "onegaishimasu";
    runtimeInputs = with pkgs; [just];
    text =
      /*
      bash
      */
      ''
        #!/bin/bash

        just -f ~/.setup/justfile -d ~/.setup "$@"
      '';
  };
in {
  environment.systemPackages = [
    onegaishimasu
  ];
}
