{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.security.doas;
in
{
  options.${namespace}.security.doas = with types; {
    enable = mkEnableOption "doas";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ doas-sudo-shim ];

    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
          }
        ];
      };
      polkit.enable = true;
    };
  };
}
