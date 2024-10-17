{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system.admin;
in
  with lib; {
    options.jeomod.system.admin = {
    };

    config = {
      environment.systemPackages = with pkgs; [doas-sudo-shim];
      security = {
        sudo.enable = false;
        doas = {
          enable = true;
          extraRules = [
            {
              users = [config.jeomod.user];
              persist = true;
            }
          ];
        };
        polkit.enable = true;
      };
      jeomod.groups = ["wheel"];
    };
  }
