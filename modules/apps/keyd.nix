{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.keyd;
in
{
  options.${namespace}.apps.keyd = {
    enable = mkEnableOption "keyd";
  };

  config = mkIf cfg.enable {
    ${namespace}.user.extraGroups = [
      "input"
      "uinput"
    ];

    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(layer1, esc)";
            };
            layer1 = {
              h = "left";
              j = "down";
              k = "up";
              l = "right";
              a = "previoussong";
              s = "playpause";
              d = "nextsong";
              q = "mute";
              w = "volumedown";
              e = "volumeup";
            };
          };
        };
      };
    };
  };
}
