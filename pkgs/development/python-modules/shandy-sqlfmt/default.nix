{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, click
, tqdm
, platformdirs
, importlib-metadata
, tomli
, jinja2
, black
, gitpython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "shandy-sqlfmt";
  version = "0.21.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "shandy_sqlfmt";
    inherit version;
    hash = "sha256-cHBxLQ97wDPmFQ+BJ+ExB+AmhcPyAV6iHPS8x+8mt4o=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    tqdm
    platformdirs
    importlib-metadata
    tomli
    jinja2
  ];

  nativeCheckInputs = [
    # pytestCheckHook
  ];

  passthru.optional-dependencies = {
    jinjafmt = [ black ];
    sqlfmt_primer = [ gitpython ];
  };

  meta = with lib; {
    description = "sqlfmt formats your dbt SQL files so you don't have to";
    changelog = "https://github.com/tconbeer/sqlfmt/releases/tag/v${version}";
    homepage = "https://github.com/tconbeer/sqlfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ nrabulinski ];
  };
}
