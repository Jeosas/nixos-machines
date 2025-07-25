{
  pkgs,
  namespace,
  config,
  ...
}:
let
  choudai = pkgs.writeShellApplication {
    name = "choudai";
    runtimeInputs = with pkgs; [ just ];

    text =
      # bash
      ''
        just -f ~/.setup/justfile -d ~/.setup "$@"
      '';
  };
in
{
  config = {
    ${namespace}.apps = {
      # keep-sorted start case=no numeric=yes
      bash.enable = true;
      bat.enable = true;
      blender.enable = true;
      btop.enable = true;
      direnv.enable = true;
      docker.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      ghostty.enable = true;
      git.enable = true;
      inkscape.enable = true;
      jj.enable = true;
      kitty.enable = true;
      krita.enable = true;
      libreoffice.enable = true;
      mullvad.enable = true;
      neovim.enable = true;
      qemu.enable = true;
      signal.enable = true;
      starship.enable = true;
      tldr.enable = true;
      transmission.enable = true;
      vesktop.enable = true;
      xournal.enable = true;
      yazi.enable = true;
      # keep-sorted end
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs; [
        # keep-sorted start case=no numeric=yes
        choudai
        mpv
        ripgrep
        termscp
        dua
        # keep-sorted end
      ];
    };
  };
}
