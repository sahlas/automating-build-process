#!/bin/bash

set -e #if any line fails the entire program fails
set -x #echo each line before executing it
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>& 1 && pwd )"

function try-load-dotenv {
    if [ ! -f "${THIS_DIR}/.env" ]; then
        echo "no .env file found"
        return 1
    fi
        # load environment variables from .env file
        while read -r line; do
                export "$line"
        done < <(grep -v '^#' "${THIS_DIR}/.env" | grep -v '^$')
}

function usage {
    echo "Usage: $0 <task> <args>"
    echo "Tasks:"
    echo "  install       Install the package and its dependencies"
    echo "  build         Build the package"
    echo "  publish       Publish the package to PyPI"
    echo "  install_dev   Install the package in development mode"
    echo "  clean         Clean up cached files"
    echo "  test          Run tests"
    echo "  lint          Run linters"
    echo "  format        Run formatters"
    echo "  check         Run linters and formatters"
    echo "  run           Run the program"
}
function help {
    echo "$0 <task> <args>"
    echo "Tasks:"
    compgen -A function | cat -n
}

function install {
    python -m pip install --upgrade pip
    python -m pip install --editable "${THIS_DIR}/[dev]"
}

function build {
    python -m pip install --upgrade pip
    python -m pip install build
    python -m pip install twine
    python -m build --sdist --wheel  "${THIS_DIR}/"
}

function publish:test {
    try-load-dotenv || true
    # publish the package to pypi
    twine upload dist/* \
        --verbose \
        --repository testpypi \
        --username __token__ \
        --password "$TEST_PYPI_PASSWORD"
}

function publish:prod {
    try-load-dotenv || true
    # publish the package to pypi
    twine upload dist/* \
        --repository pypi \
        --username __token__ \
        --password "$PROD_PYPI_PASSWORD"
}

function release:test {
    lint
    clean
    build
    publish:test
}

function release:prod {
    release:test
    publish:prod
}

function install_dev {
    # install the package in development mode
    python -m pip install --editable "${THIS_DIR}/[dev]"
}

function clean {
    # clean up cached files
    rm -rf dist build test-reports coverage.xml

    find "${THIS_DIR}" \
      -type d \
      \( \
        -name "*cache*" \
        -o -name "*.dist-info" \
        -o -name "*.egg-info" \
        -o -name "htmlcov" \
        \) \
      -not -path "${THIS_DIR}/*env/*" \
      -exec rm -r {} +
}

function lint {
    pre-commit run --all-files
}

function lint:ci {
    SKIP=no-commit-to-branch pre-commit run --all-files
}

function format {
    # run formatters
    black --line-length 120
    isort --profile black
}

function check {
    # run linters
    flake8 --max-line-length=120 --ignore=E501,E203,E266,E402,W503,W504,E731,E722,E501,E722,E1101,E1102,E1103,E1104,E1105,E1106,E1107,E1108,E1109,E1110,E1111,E1112,W504,W505,W506,W507,W508,W509,W510,W511,W512,W513,W514,W515,W516,W517,W518,W519,W520,W521,W522,W523,W524,W525,W526,W527,W528,W529
    mypy --ignore-missing-imports --follow-imports=skip --strict --show-error-codes --show-column-numbers
    black --check --line-length 120
    isort --check-only --profile black
}

function test:quick {
    # Run only quick tests, if none specified, run all tests
    PYTEST_EXIT_STATUS=0
    python -m pytest -m 'not slow' "${@:-$THIS_DIR/tests}" \
        --cov "$THIS_DIR/python_project_00" \
        --cov-report html \
        --cov-report term \
        --cov-report xml \
        --junitxml $THIS_DIR/test-reports/report.xml \
        --cov-fail-under=10 || ((PYTEST_EXIT_STATUS=$?))
    mv coverage.xml "$THIS_DIR/test-reports/"
    mv htmlcov "$THIS_DIR/test-reports/"
}

# (example) ./run.sh test tests/test_slow.py::test_slow_add_with_delay
function test:ci {
    INSTALLED_PKG_DIR="$(python -c 'import python_project_00; print(python_project_00.__path__[0])')"
    # in CI, we must calculate the coverage for the installed package, not the src/ folder
    COVERAGE_DIR="$INSTALLED_PKG_DIR" run-tests
}

# (example) ./run.sh test tests/test_states_info.py::test__slow_add
function run-tests {
    PYTEST_EXIT_STATUS=0
    python -m pytest ${@:-"$THIS_DIR/tests/"} \
        --cov "${COVERAGE_DIR:-$THIS_DIR/python_project_00}" \
        --cov-report html \
        --cov-report term \
        --cov-report xml \
        --junit-xml "$THIS_DIR/test-reports/report.xml" \
        --cov-fail-under 60 || ((PYTEST_EXIT_STATUS+=$?))
    mv coverage.xml "$THIS_DIR/test-reports/" || true
    mv htmlcov "$THIS_DIR/test-reports/" || true
    mv .coverage "$THIS_DIR/test-reports/" || true
    return $PYTEST_EXIT_STATUS
}

function test:wheel-locally {
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
        echo "Virtual environment deactivated."
    else
        echo "No active virtual environment to deactivate."
    fi

    rm -rf ./test-venv || true
    python -m venv ./test-venv
    source ./test-venv/bin/activate
    clean || true
    pip install build
    build
    pip install ./dist/*.whl pytest pytest-cov
    test:ci
}

function serve-coverage-report {
    # serve the coverage report
    python -m http.server --directory test-reports/htmlcov
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help} # if nothing in @ do left
