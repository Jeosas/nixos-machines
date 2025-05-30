{ appimageTools, fetchurl }:
let
  pname = "ankama-launcher";
  version = "latest";
  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage";
    sha256 = "d9FEXVuN7wiilskKhPbp/ssn16l8F1a/C6VBNVv3x20=";
    name = "ankama-launcher.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit src pname version;
  };
in
appimageTools.wrapType2 {
  inherit src pname version;

  extraInstallCommands = # bash
    ''
      install -m 444 -D ${appimageContents}/zaap.desktop "$out/share/applications/ankama-launcher.desktop"
      sed -i 's/.*Exec.*/Exec=ankama-launcher/' "$out/share/applications/ankama-launcher.desktop"
      install -m 444 -D ${appimageContents}/zaap.png "$out/share/icons/hicolor/256x256/apps/zaap.png"
    '';
}
