{ lib, ... }:
with lib;
rec {
  ## Create a NixOS module option.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  ## Create a NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkOpt' nixpkgs.lib.types.str "My default"
  ## ```
  ##
  #@ Type -> Any
  mkOpt' = type: default: mkOpt type default null;

  ## Create a NixOS module hex color option.
  ##
  ## ```nix
  ## lib.mkcolorOpt "primary"
  ## ```
  ##
  #@ String -> String
  mkColorOpt =
    { name, default }:
    {
      inherit name;
      value = mkOpt (lib.types.strMatching "#[a-fA-F0-9]{6}") default "Color for ${name}.";
    };

  ## Quickly enable an option.
  ##
  ## ```nix
  ## services.nginx = enabled;
  ## ```
  ##
  enabled = {
    enable = true;
  };

  ## Quickly disable an option.
  ##
  ## ```nix
  ## services.nginx = enabled;
  ## ```
  ##
  disabled = {
    enable = false;
  };
}
