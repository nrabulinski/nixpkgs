{ lib
, python3Packages
, fetchPypi

, withPostgres ? true
, withMysql ? true
, withOdbc ? true
, withBigquery ? true
, withTrino ? true
}: let
  harlequin-postgres = python3Packages.buildPythonPackage rec {
    pname = "harlequin-postgres";
    version = "0.2.2";
    pyproject = true;

    disabled = python3Packages.pythonOlder "3.8.1";

    src = fetchPypi {
      pname = "harlequin_postgres";
      inherit version;
      hash = "sha256-IF8ueqYjwaG9I1S4+h04sz4pYpIxgxaFhspGiPsay4E=";
    };

    nativeBuildInputs = with python3Packages; [
      poetry-core
      pythonRelaxDepsHook
    ];

    pythonRemoveDeps = [
      "harlequin"
      "psycopg2-binary"
    ];

    propagatedBuildInputs = with python3Packages; [ psycopg2 ];
  };
  harlequin-mysql = python3Packages.buildPythonPackage rec {
    pname = "harlequin-mysql";
    version = "0.1.1";
    pyproject = true;

    disabled = python3Packages.pythonOlder "3.8.1";

    src = fetchPypi {
      pname = "harlequin_mysql";
      inherit version;
      hash = "sha256-zjYps+OC8I2sKd8zIaOeflugaYpt3cluznBm26Ny/qc=";
    };

    nativeBuildInputs = with python3Packages; [
      poetry-core
      pythonRelaxDepsHook
    ];

    pythonRemoveDeps = [ "harlequin" ];

    pythonRelaxDeps = [ "mysql-connector-python" ];

    propagatedBuildInputs = with python3Packages; [ mysql-connector ];
  };
in python3Packages.buildPythonApplication rec {
  pname = "harlequin";
  version = "1.11.0";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s7RyBQFRUTX6ye9APIhmg1F8pv5DQkAW0ZgUA20Qc7o=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "textual"
  ];

  propagatedBuildInputs = with python3Packages; [
    textual
    textual-fastdatatable
    textual-textarea

    click
    rich-click

    duckdb
    shandy-sqlfmt
    platformdirs
    pyperclip
    importlib-metadata
    tomli
    tomlkit
    questionary
  ]
  ++ lib.optionals withPostgres [harlequin-postgres]
  ++ lib.optionals withMysql [harlequin-mysql];

  nativeCheckInputs = with python3Packages; [
  ];

  meta = with lib; {
    mainProgram = "harlequin";
    changelog = "https://github.com/tconbeer/harlequin/releases/tag/v${version}";
    description = "The SQL IDE for Your Terminal";
    homepage = "https://github.com/tconbeer/harlequin";
    license = licenses.mit;
    maintainers = with maintainers; [ nrabulinski ];
  };
}
