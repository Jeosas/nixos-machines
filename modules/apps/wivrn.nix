{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.wivrn;
in
{
  options.${namespace}.apps.wivrn = {
    enable = mkEnableOption "wivrn";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;

    services.wivrn = {
      enable = true;
      package = pkgs.wivrn.override { cudaSupport = true; };
      autoStart = true;
      openFirewall = true;
      defaultRuntime = true;
      # config = {
      #   enable = true;
      #   json = {};
      # };
    };

    ${namespace} = {
      user.extraGroups = [ "adbusers" ];
    };

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/wivrn"
      ".config/openvr"
      ".config/openxr"
    ];

  };
}
