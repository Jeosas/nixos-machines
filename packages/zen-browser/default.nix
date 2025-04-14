{ appimageTools, fetchurl }:
let
  pname = "zen";
  version = "1.10.3";
  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}b/zen-x86_64.AppImage";
    sha256 = "H3rxDi0xoN7xYSysmOndZE6feQVO7UgZLE7DSwN30AQ=";
    name = "zen-x86_64.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit src pname version;
  };
in
appimageTools.wrapType2 {
  inherit src pname version;

  extraInstallCommands = # bash
    ''
      install -m 444 -D ${appimageContents}/zen.desktop "$out/share/applications/zen.desktop"
      sed -i 's/.*Exec.*/Exec=zen/' "$out/share/applications/zen.desktop"
      install -m 444 -D ${appimageContents}/zen.png "$out/share/icons/hicolor/256x256/apps/zen.png"
    '';
}
