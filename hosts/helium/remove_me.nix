{ ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
  ];
}
