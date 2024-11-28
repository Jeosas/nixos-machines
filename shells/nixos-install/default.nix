{pkgs, ...}:
pkgs.mkShell {
  name = "nixos-install";
  packages = with pkgs; [nixos-install-tools];
}
