{
  appimageTools,
  fetchurl,
}: let
  name = "ankama-launcher";
  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage";
    sha256 = "45r1cWDqZfTw/DTk9RRFdubNC/dycweKhp3hLWd4qgI=";
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
