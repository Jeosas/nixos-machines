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
    ankama-launcher = mkPackage ./packages/ankama-launcher;
    neovim = mkPackage ./packages/neovim;
    nordzy-cursors = mkPackage ./packages/nordzy-cursors;

    inherit (inputs.ongaku.packages.${prev.system}) ongaku;
  };
}
