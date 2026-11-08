{ pkgs, ... }:
pkgs.writeShellApplication {
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
}
