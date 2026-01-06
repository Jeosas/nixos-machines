{
  symlinkJoin,
  makeWrapper,
  writeText,
  wayland-bongocat,
  keyboard_device ? "/dev/input/event5",
}:
let
  baseConfigFile = builtins.readFile ./bongocat.conf;

  configFile = writeText "bongocat.conf" ''
    keyboard_device=${keyboard_device}

    ${baseConfigFile}
  '';
in
symlinkJoin {
  name = "bongocat";
  paths = [
    wayland-bongocat
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/bongocat \
      --add-flags "-c" \
      --add-flags "${configFile}"
  '';
}
