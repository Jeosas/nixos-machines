{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.virtualisation.qemu;
in
with lib;
{
  options.${namespace}.virtualisation.qemu = {
    enable = mkEnableOption "Qemu";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
      quickemu
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      ${namespace}.impermanence.directories = [ "vm" ];
    };
  };
}
