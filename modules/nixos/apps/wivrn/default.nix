{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.wivrn;
in
with lib;
{
  options.${namespace}.apps.wivrn = {
    enable = mkEnableOption "wivrn";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;

    services.wivrn = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      defaultRuntime = true;
      # config = {
      #   enable = true;
      #   json = {};
      # };

      extraPackages =
        with pkgs;
        mkIf config.hardware.graphics.nvidia.enable [
          monado-vulkan-layers
        ];
    };

    ${namespace} = {
      impermanence.userDirectories = [
        ".config/wivrn"
        ".config/openvr"
        ".config/openxr"
      ];

      user.extraGroups = [ "adbusers" ];
    };
  };
}
