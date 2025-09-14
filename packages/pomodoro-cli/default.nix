{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "pomodoro-cli";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "jkallio";
    repo = pname;
    rev = "v.${version}";
    sha256 = "sha256-lyBevSfsw6ZrCzvc5Tkp0N7Szy7qleLwNnbNikaKC8c=";
  };

  cargoHash = "sha256-hT4WPLOSiFEIivVJPa7RWFk9ZzNpaYmPHRdn/lIY43o=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib.dev ];

  # Point cache and tmp directories to a writable location
  # (needed for tests)
  preCheck = ''
    export XDG_CACHE_HOME="$(pwd)/tmp/cache";
    mkdir -p $XDG_CACHE_HOME;
  '';
}
