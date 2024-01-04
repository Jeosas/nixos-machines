{ pkgs, inputs }:

inputs.home-manager.lib.homeManagerConfiguration rec {
  inherit pkgs;
  extraSpecialArgs = { inherit inputs; };
  modules = [
    ./configuration.nix
    ./home.nix
    ./bash_to_zsh.nix
  ];
}
