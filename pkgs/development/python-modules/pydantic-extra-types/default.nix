{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  semver,
  pendulum,
  phonenumbers,
  pycountry,
  python-ulid,
  pytz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
  version = "2.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    tag = "v${version}";
    hash = "sha256-hjwComN2CQWPnF7frWobxbzN9/ZhHGVSsRHnmAkL6wk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    semver
  ];

  optional-dependencies = {
    all = [
      pendulum
      phonenumbers
      pycountry
      python-ulid
      pytz
    ];
  };

  pythonImportsCheck = [ "pydantic_extra_types" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  disabledTests = [
    # outdated jsonschema fixture
    "test_json_schema"
  ];

  # PermissionError accessing '/etc/localtime'
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_pendulum_dt.py" ];

  meta = with lib; {
    changelog = "https://github.com/pydantic/pydantic-extra-types/blob/${src.tag}/HISTORY.md";
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = licenses.mit;
    maintainers = [ ];
  };
}
