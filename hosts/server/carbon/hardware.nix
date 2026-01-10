{ _, ... }:
{
  imports = [ ./_hardware.nix ];

  fileSystems."/boot".options = [ "nofail" ];
  fileSystems."/boot-fallback".options = [ "nofail" ];
}
