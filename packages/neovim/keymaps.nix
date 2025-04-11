{ _, ... }:
let
  options = {
    noremap = true;
    silent = true;
  };

  mkKeymap = mode: key: action: {
    inherit
      mode
      key
      action
      options
      ;
  };
in
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps = [
    # Disable leader
    (mkKeymap "" "<Space>" "<Nop>")
    # Disable Ex mode
    (mkKeymap "n" "Q" "<Nop>")

    # Navigation
    (mkKeymap "n" "<C-h>" "<C-w>h")
    (mkKeymap "n" "<C-j>" "<C-w>j")
    (mkKeymap "n" "<C-k>" "<C-w>k")
    (mkKeymap "n" "<C-l>" "<C-w>l")
    (mkKeymap "n" "<A-l>" ":bnext<CR>")
    (mkKeymap "n" "<A-h>" ":bprevious<CR>")

    # Moving text around
    (mkKeymap [ "n" "v" "x" ] "<A-j>" "<Esc>:m .+1<CR>==")
    (mkKeymap [ "n" "v" "x" ] "<A-k>" "<Esc>:m .-2<CR>==")
    (mkKeymap "v" "<" "<gv")
    (mkKeymap "v" ">" ">gv")

    # Buffer recentering
    (mkKeymap "n" "<C-u>" "<C-u>zz")
    (mkKeymap "n" "<C-d>" "<C-d>zz")
    (mkKeymap "n" "n" "nzzzv")
    (mkKeymap "n" "N" "Nzzzv")
    (mkKeymap "n" "*" "*zzzv")
    (mkKeymap "n" "#" "#zzzv")

    # Keep yank text when pasting in VISUAL mode
    (mkKeymap "x" "p" ''"_dP'')
  ];
}
