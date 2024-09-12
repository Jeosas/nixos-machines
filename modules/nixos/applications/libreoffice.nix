{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.libreoffice;
in
  with lib; {
    options.jeomod.applications.libreoffice = {
      enable = mkEnableOption "Libreoffice";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [
        libreoffice
        hunspell # spellcheck and its dicts
        hunspellDicts.fr-any
        hunspellDicts.en-us
        hunspellDicts.de-de
      ];
    };
  }
