{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  rustPlatform,
  cmake,
  libiconv,
  fetchFromGitHub,
  typing-extensions,
  jemalloc,
  rust-jemalloc-sys,
  darwin,
}:

let
  rust-jemalloc-sys' = rust-jemalloc-sys.override {
    jemalloc = jemalloc.override { disableInitExecTls = true; };
  };
in

buildPythonPackage rec {
  pname = "polars";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pola-rs";
    repo = "polars";
    rev = "refs/tags/py-${version}";
    hash = "sha256-qJTBGGRxMAirgygm7Ke60olO5sTZboZ80JkYI0LZSMk=";
  };

  # Cargo.lock file is sometimes behind actual release which throws an error,
  # thus the `sed` command
  # Make sure to check that the right substitutions are made when updating the package
  preBuild = ''
    #sed -i 's/version = "0.18.0"/version = "${version}"/g' Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes."numpy-0.21.0" = "sha256-u0Z+6L8pXSPaA3cE1sUpY6sCoaU1clXUcj/avnNzmsw=";
  };

  buildAndTestSubdir = "py-polars";

  # Revisit this whenever package or Rust is upgraded
  RUSTC_BOOTSTRAP = 1;

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  # trick taken from the polars repo since there seems to be a problem
  # with simd enabled with our stable rust (instead of nightly).
  maturinBuildFlags = [
    "--no-default-features"
    "--all-features"
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs =
    [
      # needed for libz-ng-sys
      # TODO: use pkgs.zlib-ng
      cmake
    ]
    ++ (with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
    ]);

  buildInputs =
    [ rust-jemalloc-sys' ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # nativeCheckInputs = [
  #   pytestCheckHook
  #   fixtures
  #   graphviz
  #   matplotlib
  #   networkx
  #   numpy
  #   pydot
  # ];

  pythonImportsCheck = [ "polars" ];

  meta = with lib; {
    description = "Fast multi-threaded DataFrame library";
    homepage = "https://github.com/pola-rs/polars";
    changelog = "https://github.com/pola-rs/polars/releases/tag/py-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
