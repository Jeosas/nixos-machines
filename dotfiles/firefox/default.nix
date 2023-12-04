{ inputs, config, pkgs, ... }:

{ }

/*
  # https://discourse.nixos.org/t/best-way-to-configure-firefox-extensions/32600
  # https://gitlab.com/rycee/nur-expressions
  # https://haseebmajid.dev/posts/2023-06-22-til-use-nur-with-home-manager-flake/
  # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.enable
  # https://nixos.wiki/wiki/Firefox

  User settings are all gathered in /home/jeosas/.mozilla/firefox/2y70asbk.default-release/prefs.js
  Also all the UI settings (addon placement etc..) is stored in settings (browser.uiCustomization.state)

  can't find a way to configure addons, may look into replace tree style tabs by a userChrome config since it is enough for me.


*/
