{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, textual
, pyarrow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "textual-fastdatatable";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "textual_fastdatatable";
    inherit version;
    hash = "sha256-hRUOHi5idU+E1v9JRcHH4ABzEQfBhQ5VKL2zT3G0viw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    textual
    pyarrow
  ];

  nativeCheckInputs = [
    # pytestCheckHook
  ];

  meta = with lib; {
    description = "A performance-focused reimplementation of Textual's DataTable widget, with a pluggable data storage backend";
    changelog = "https://github.com/tconbeer/textual-fastdatatable/releases/tag/v${version}";
    homepage = "https://github.com/tconbeer/textual-fastdatatable";
    license = licenses.mit;
    maintainers = with maintainers; [ nrabulinski ];
  };
}
