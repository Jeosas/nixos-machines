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
    pomodoro-cli = mkPackage ./packages/pomodoro-cli;

    inherit (inputs.ongaku.packages.${prev.system}) ongaku;
    inherit (inputs.maudfmt.packages.${prev.system}) maudfmt;
  };
}
