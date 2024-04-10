{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    just
    bat
    ripgrep
    btop
    ncpamixer
  ];

  programs.ranger = {
    enable = true;
    settings = {
      show_hidden = true;
      use_preview_script = true;
      # TODO: activate when 1.9.4 release
      # preview_images = true;
      # preview_images_method = "sixel";
    };
    extraConfig = ''
      default_linemode devicons
    '';
    plugins = [
      {
        name = "ranger_devicons";
        src = builtins.fetchGit {
          url = "https://github.com/alexanderjeurissen/ranger_devicons.git";
          rev = "ed718dd6a6d5d2c0f53cba8474c5ad96185057e9";
        };
      }
    ];
    extraPackages = with pkgs; [ imagemagick ];
  };
}
