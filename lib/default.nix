{lib, ...}:
with lib; rec {
  ## Create a NixOS module option.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt = type: default: description:
    mkOption {inherit type default description;};

  ## Create a NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkOpt' nixpkgs.lib.types.str "My default"
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt' = type: default: mkOpt type default null;

  ## Quickly enable an option.
  ##
  ## ```nix
  ## services.nginx = enabled;
  ## ```
  ##
  #@ true
  enabled = {enable = true;};

  ## Quickly disable an option.
  ##
  ## ```nix
  ## services.nginx = enabled;
  ## ```
  ##
  #@ false
  disabled = {enable = false;};
}
