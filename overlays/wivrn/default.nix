{ channels, ... }:
final: prev: {
  inherit (channels.unstable) wivrn;
}
