{ appimageTools, fetchurl }:
let
  name = "ankama-launcher";
  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage";
    sha256 = "6HJqmADjrQqr2Vm/mXnRN/BMPv6qcP7kU7xyTzLJQRA=";
    name = "ankama-launcher.AppImage";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = # bash
    ''
      install -m 444 -D ${appimageContents}/zaap.desktop "$out/share/applications/ankama-launcher.desktop"
      sed -i 's/.*Exec.*/Exec=ankama-launcher/' "$out/share/applications/ankama-launcher.desktop"
      install -m 444 -D ${appimageContents}/zaap.png "$out/share/icons/hicolor/256x256/apps/zaap.png"
    '';
}
