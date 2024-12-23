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
    home.packages = with pkgs; [ monero-gui ];
    ${namespace}.impermanence.directories = [
      ".config/monero-project"
      "Monero/wallets"
    ];
  };
}
