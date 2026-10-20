{
  lib,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  # fetchPypi,
  pari,
  pkg-config,
  gmp,
  meson-python,
  cython,
  cysignals,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "cypari2";
  # upgrade may break sage, please test the sage build or ping the sage team on upgrade
  version = "2.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "cypari2";
    tag = "${version}";
    hash = "sha256-Z46xxoFTRBRiCEJEpcYEtSQgYmTaHLXqWemuRM4G9mw=";
  };

  build-system = [
    meson-python
    cython
    cysignals
  ];

  nativeBuildInputs = [
    pari
    pkg-config
  ];

  buildInputs = [
    gmp
    pari
  ];

  checkPhase = ''
    test -f "$out/${python.sitePackages}/cypari2/auto_paridecl.pxd"
    make check
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Cython bindings for PARI";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    homepage = "https://github.com/sagemath/cypari2";
  };
}
