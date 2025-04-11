extra@{
  namespace,
  lib,
  inputs,
}:
final: prev:
let
  extra-inputs = final // extra;
  mkPackage = path: extra-inputs.lib.callPackageWith extra-inputs path { };
in
{
  ${namespace} = (prev.${namespace} or { }) // {
    ankama-launcher = mkPackage ./ankama-launcher;
    neovim = mkPackage ./neovim;
    nordzy-cursors = mkPackage ./nordzy-cursors;
    zen-browser = mkPackage ./zen-browser;
  };
}
