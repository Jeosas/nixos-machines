{
  pkgs,
  inputs,
}:
inputs.home-manager.lib.homeManagerConfiguration rec {
  inherit pkgs;
  extraSpecialArgs = {inherit inputs;};
  modules = [
    ./home.nix
  ];
}
