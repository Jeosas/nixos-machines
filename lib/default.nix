self: super:
{ namespace }:
let
  inherit (builtins)
    baseNameOf
    toString
    ;
  inherit (self)
    last
    mkOption
    ;
  inherit (self.filesystem) listFilesRecursive;

  fileNameRegex = "(.*)\\.(.*)$";
in
rec {
  vars = import ./vars.nix;

  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  #@ Type -> Any
  mkOpt' = type: default: mkOpt type default null;

  #@ Type -> String
  mkOptRequired = type: description: mkOption { inherit type description; };

  #@ String -> String
  mkColorOpt =
    { name, default }:
    {
      inherit name;
      value = mkOpt (self.types.strMatching "#[a-fA-F0-9]{6}") default "Color for ${name}.";
    };

  ## Quickly enable an option.
  # TODO: remove this
  enabled = {
    enable = true;
  };

  ## Quickly disable an option.
  # TODO: remove this
  disabled = {
    enable = false;
  };

  #@ Bool -> Bool -> Bool
  xor = a: b: ((a && !b) || (!a && b));

  # --- PATH

  #@ Path -> Bool
  hasAnyFileExtension =
    file:
    let
      match = builtins.match fileNameRegex (toString file);
    in
    match != null;

  #@ Path -> String
  getFileExtension =
    file:
    if hasAnyFileExtension file then
      let
        match = builtins.match fileNameRegex (toString file);
      in
      last match
    else
      "";

  #@ Path -> String -> Bool
  hasFileExtension =
    extension: file: if hasAnyFileExtension file then extension == getFileExtension file else false;

  # --- FILESYSTEM

  #@ Path -> [Path]
  getNixFilesRecursive = path: builtins.filter (hasFileExtension "nix") (listFilesRecursive path);

  #@ Path -> [Path]
  getDefaultNixFilesRecursive =
    path: builtins.filter (name: baseNameOf name == "default.nix") (listFilesRecursive path);

  #@ Path -> [Path]
  getNonDefaultNixFilesRecursive =
    path:
    builtins.filter (
      name: (hasFileExtension "nix" name) && (builtins.baseNameOf name != "default.nix")
    ) (listFilesRecursive path);

  # --- FLAKE

  #@ List String -> `nixpkgs` -> (`pkgs` -> Attrs) -> Attrs
  forAllSystems =
    supportedSystems:
    {
      nixpkgs,
      nixpkgsConfig ? { },
    }:
    function:
    self.genAttrs supportedSystems (
      system: function (import nixpkgs ({ inherit system; } // nixpkgsConfig))
    );

  #@ `nixpkgs` -> `lib`
  extendLib =
    lib_: lib_.extend (self: super: { ${namespace} = import ./. self super { inherit namespace; }; });
}
