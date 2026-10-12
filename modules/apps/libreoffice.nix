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
      # hunspellDicts.fr # https://github.com/NixOS/nixpkgs/issues/480639
      hunspellDicts.en-us
      hunspellDicts.de-de
    ];
  };
}
