{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.vagrant;
in
  with lib; {
    options.jeomod.applications.vagrant = {
      enable = mkEnableOption "Vagrant";
    };

    config = mkIf cfg.enable {
      virtualisation.virtualbox.host.enable = true;

      environment.systemPackages = with pkgs; [
        (vagrant.override {withLibvirt = false;}) # TODO remove when #348938 fixed
      ];
      jeomod = {
        groups = ["user-with-access-to-virtualbox"];
        system.impermanence.user.directories = [".vagrant.d" "VirtualBox VMs" ".config/VirtualBox"];
      };
    };
  }
