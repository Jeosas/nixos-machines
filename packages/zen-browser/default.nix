{ appimageTools, fetchurl }:
let
  name = "zen";
  version = "1.8.2";
  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}b/zen-x86_64.AppImage";
    sha256 = "hZiJ8JLzLhtD1W8DAso3yBAJYhFE+nJEbQJa59AWjnU=";
    name = "zen-x86_64.AppImage";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  pname = name;
  inherit version;

  inherit src;

  extraInstallCommands = # bash
    ''
      install -m 444 -D ${appimageContents}/zen.desktop "$out/share/applications/zen.desktop"
      sed -i 's/.*Exec.*/Exec=zen/' "$out/share/applications/zen.desktop"
      install -m 444 -D ${appimageContents}/zen.png "$out/share/icons/hicolor/256x256/apps/zen.png"
    '';
}
