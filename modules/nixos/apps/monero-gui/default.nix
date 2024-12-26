{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.monero-gui;
in
with lib;
{
  options.${namespace}.apps.monero-gui = {
    enable = mkEnableOption "monero-gui";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ monero-gui ];
    ${namespace}.impermanence.userDirectories = [
      ".config/monero-project"
      "Monero/wallets"
    ];
  };
}
