{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.apps.libreoffice;
in
  with lib; {
    options.${namespace}.apps.libreoffice = {enable = mkEnableOption "Libreoffice";};

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        libreoffice
        hunspell # spellcheck and its dicts
        hunspellDicts.fr-any
        hunspellDicts.en-us
        hunspellDicts.de-de
      ];
    };
  }
