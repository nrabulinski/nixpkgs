{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, textual
, pyperclip
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "textual-textarea";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "textual_textarea";
    inherit version;
    hash = "sha256-SGntKLoBu1VzkSJ+uET1f/QFI8jzNDhjyJKpFtu3abk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    textual
    pyperclip
  ];

  nativeCheckInputs = [
    # TODO: Tests
    # pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    description = "A text area (multi-line input) with syntax highlighting and autocomplete for Textual";
    changelog = "https://github.com/tconbeer/textual-textarea/releases/tag/v${version}";
    homepage = "https://github.com/tconbeer/textual-textarea";
    license = licenses.mit;
    maintainers = with maintainers; [ nrabulinski ];
  };
}
