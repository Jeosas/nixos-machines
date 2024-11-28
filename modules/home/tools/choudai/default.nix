{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.tools.choudai;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.tools.choudai = {
      enable = mkEnableOption "choudai";
    };
    config = mkIf cfg.enable {
      home.packages = with pkgs; [just];
      programs.zsh.shellAliases = {
        choudai = "${pkgs.just}/bin/just -f ~/.setup/justfile -d ~/.setup \"$@\"";
      };
    };
  }
