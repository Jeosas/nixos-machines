{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.qemu;
in
{
  options.${namespace}.apps.qemu = {
    enable = mkEnableOption "Qemu";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
      quickemu
    ];

    ${namespace}.impermanence.userDirectories = [ "vm" ];
  };
}
