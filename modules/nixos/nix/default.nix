{
  config = {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 1w";
      };
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;

        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
  };
}
