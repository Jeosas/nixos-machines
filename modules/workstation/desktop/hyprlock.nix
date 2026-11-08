{
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkForce;
in
{
  config = {
    programs.hyprlock.enable = true;
    services.hypridle.enable = mkForce false;

    ${namespace} = {
      apps.stow.groups = [ "hyprlock" ];
    };
  };
}
