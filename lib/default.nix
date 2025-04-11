self: super:
{ namespace }:
let
  inherit (builtins)
    readDir
    assertMsg
    pathExists
    last
    toString
    baseNameOf
    ;
  inherit (self)
    filterAttrs
    genAttrs
    mkOption
    mapAttrsToList
    flatten
    ;

  inherit (self.${namespace}) pathLib fsLib;
in
rec {
  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  #@ Type -> Any
  mkOpt' = type: default: mkOpt type default null;

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

  path =
    let
      fileNameRegex = "(.*)\\.(.*)$";
    in
    rec {
      #@ String -> [String]
      splitFileExtension =
        file:
        let
          match = builtins.match fileNameRegex file;
        in
        assert assertMsg (
          match != null
        ) "lib.${namespace}.splitFileExtension - File must have an extension to split: ${file}";
        match;
      #@ String -> Bool
      hasAnyFileExtension =
        file:
        let
          match = builtins.match fileNameRegex (toString file);
        in
        match != null;

      #@ String -> String
      getFileExtension =
        file:
        if hasAnyFileExtension file then
          let
            match = builtins.match fileNameRegex (toString file);
          in
          last match
        else
          "";

      #@ String -> String -> Bool
      hasFileExtension =
        extension: file: if hasAnyFileExtension file then extension == getFileExtension file else false;
    };

  fs = rec {
    #@ String -> Bool
    isFileKind = kind: kind == "regular";
    isSymlinkKind = kind: kind == "symlink";
    isDirectoryKind = kind: kind == "directory";
    isUnknownKind = kind: kind == "unknown";

    #@ String -> String
    getFile = path: ../${path};

    #@ Path -> Attrs
    safeReadDirectory = path: if pathExists path then readDir path else { };

    #@ Path -> [Path]
    getDirectories =
      path:
      let
        entries = safeReadDirectory path;
        filteredEntries = filterAttrs (_: isDirectoryKind) entries;
      in
      mapAttrsToList (name: kind: "${path}/${name}") filteredEntries;

    #@ Path -> [Path]
    getFiles =
      path:
      let
        entries = safeReadDirectory path;
        filteredEntries = filterAttrs (_: isFileKind) entries;
      in
      mapAttrsToList (name: kind: "${path}/${name}") filteredEntries;

    #@ Path -> [Path]
    getFilesRecursive =
      path:
      let
        entries = safeReadDirectory path;
        filteredEntries = filterAttrs (_: kind: (isFileKind kind) || (isDirectoryKind kind)) entries;
        map-file =
          name: kind:
          let
            path' = "${path}/${name}";
          in
          if isDirectoryKind kind then getFilesRecursive path' else path';
        mapConcatAttrsToList = f: attrs: flatten (mapAttrsToList f attrs);
        files = mapConcatAttrsToList map-file filteredEntries;
      in
      files;

    #@ Path -> [Path]
    getNixFiles = path: builtins.filter (pathLib.hasFileExtension "nix") (getFiles path);

    #@ Path -> [Path]
    getNixFilesRecursive =
      path: builtins.filter (pathLib.hasFileExtension "nix") (getFilesRecursive path);

    #@ Path -> [Path]
    getDefaultNixFiles = path: builtins.filter (name: baseNameOf name == "default.nix") (getFiles path);

    #@ Path -> [Path]
    getDefaultNixFilesRecursive =
      path: builtins.filter (name: baseNameOf name == "default.nix") (getFilesRecursive path);

    #@ Path -> [Path]
    getNonDefaultNixFiles =
      path:
      builtins.filter (
        name: (pathLib.hasFileExtension "nix" name) && (builtins.baseNameOf name != "default.nix")
      ) (getFiles path);

    #@ Path -> [Path]
    getNonDefaultNixFilesRecursive =
      path:
      builtins.filter (
        name: (pathLib.hasFileExtension "nix" name) && (builtins.baseNameOf name != "default.nix")
      ) (getFilesRecursive path);
  };

  flake = {
    #@ List String -> `nixpkgs` -> (`pkgs` -> Attrs) -> Attrs
    forAllSystems =
      supportedSystems:
      {
        nixpkgs,
        options ? { },
      }:
      function:
      self.genAttrs supportedSystems (system: function (import nixpkgs { inherit system; } // options));

    #@ `specialArgs` -> `nixpkgs` -> {modules: List Modules} -> nixosConfiguration
    mkHost =
      {
        inputs,
        lib,
        namespace,
        hosts,
      }@args:
      {
        nixpkgs,
        globalModules ? [ ],
        overlays ? [ ],
      }:
      system: path:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = args;
        modules = globalModules ++ [
          (
            { _, ... }:
            {
              nixpkgs.overlays = overlays;
            }
          )
          (import path)
        ];
      };
  };
}
