{...}: final: prev: {
  discord = prev.discord.overrideAttrs (_: {
    src = builtins.fetchTarball {
      url = "https://discord.com/api/download?platform=linux&format=tar.gz";
      sha256 = "1h3697dx4cxf32p5bfkl8y04xvn2w8sq14cjw925z6x04mb15z07";
    };
  });
}
