{ lib, pkgs, ... }:
let
  inherit (pkgs) writeShellApplication;

  launchbar = writeShellApplication {
    name = "launchbar";
    runtimeInputs = with pkgs; [
      killall
      waybar
    ];

    text =
      # bash
      ''
        killall waybar || true
        killall .waybar-wrapped || true

        waybar &
      '';
  };
in
launchbar
