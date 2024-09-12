{
  appimageTools,
  fetchurl,
}: let
  name = "ankama-launcher";
  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Wakfu-Setup-x86_64.AppImage";
    sha256 = "0wi6qq71q3296yprwcw8c9qn4l4if49bh492a21agw4bzmdkx1gs"; # Change for the sha256 you get after running nix-prefetch-url https://download.ankama.com/launcher/full/linux/x64
    name = "ankama-launcher.AppImage";
  };

  appimageContents = appimageTools.extractType2 {inherit name src;};
in
  appimageTools.wrapType2 {
    inherit name src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/zaap.desktop $out/share/applications/ankama-launcher.desktop
      sed -i 's/.*Exec.*/Exec=ankama-launcher/' $out/share/applications/ankama-launcher.desktop
      install -m 444 -D ${appimageContents}/zaap.png $out/share/icons/hicolor/256x256/apps/zaap.png
    '';
  }
