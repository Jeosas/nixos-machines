{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.libreoffice;
in
{
  options.${namespace}.apps.libreoffice = {
    enable = mkEnableOption "Libreoffice";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
      hunspell # spellcheck and its dicts
      hunspellDicts.fr-any
      hunspellDicts.en-us
      hunspellDicts.de-de
    ];
  };
}
