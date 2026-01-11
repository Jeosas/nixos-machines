{ _, ... }:
{
  imports = [ ./_hardware.nix ];

  fileSystems = {
    "/boot".options = [ "nofail" ];
    "/boot-fallback".options = [ "nofail" ];
    "/persist".neededForBoot = true;
    "/data".neededForBoot = true;
  };
}
