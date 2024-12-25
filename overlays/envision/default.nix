{ channels, ... }:
final: prev: {
  inherit (channels.unstable) envision;
}
