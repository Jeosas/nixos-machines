{inputs}: final: prev: let
  getPackages = pkgsFile: extraParams:
    prev.callPackage (import pkgsFile {inherit inputs;}) extraParams;
in {
  ongaku = inputs.ongaku.packages.${prev.system}.default;

  discord = prev.discord.overrideAttrs (_: {
    src = builtins.fetchTarball {
      url = "https://discord.com/api/download?platform=linux&format=tar.gz";
      sha256 = "1h3697dx4cxf32p5bfkl8y04xvn2w8sq14cjw925z6x04mb15z07";
    };
  });

  _7zz = final: prev: {
    _7zz = prev._7zz.override {useUasm = true;};
  };

  inherit (getPackages ./pkgs/ankama-launcher/packages.nix {}) ankama-launcher;
}
