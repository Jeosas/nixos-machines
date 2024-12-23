{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  choudai = pkgs.writeShellApplication {
    name = "choudai";
    runtimeInputs = with pkgs; [ just ];

    text =
      # bash
      ''
        just -f ~/.setup/justfile -d ~/.setup "$@"
      '';
  };

  cfg = config.${namespace}.tools.choudai;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.choudai = {
    enable = mkEnableOption "choudai";
  };
  config = mkIf cfg.enable { home.packages = [ choudai ]; };
}
