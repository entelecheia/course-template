# To do stuff with make, you type `make` in a directory that has a file called
# "Makefile".  You can also type `make -f <makefile>` to use a different filename.
#
# A Makefile is a collection of rules. Each rule is a recipe to do a specific
# thing, sort of like a grunt task or an npm package.json script.
#
# A rule looks like this:
#
# <target>: <prerequisites...>
# 	<commands>
#
# The "target" is required. The prerequisites are optional, and the commands
# are also optional, but you have to have one or the other.
#
# Type `make` to show the available targets and a description of each.
#
.DEFAULT_GOAL := help
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Clean-up

clean-cov: ## remove coverage reports
	@rm -rf .coverage* tests/htmlcov tests/pytest.xml tests/pytest-coverage.txt

clean-pycache: ## remove __pycache__ directories
	@find . -type d -name __pycache__ -exec rm -rf {} +

clean-build: ## remove build/python artifacts
	@rm -rf build dist *.egg-info

clean-docs: ## remove documentation artifacts
	@rm -rf book/_build docs/_build _site

clean: clean-cov clean-pycache clean-build clean-docs ## remove build artifacts and coverage reports

##@ Format

format-black: ## format code with black
	@black .

format-isort: ## sort imports with isort
	@isort .

format: format-black format-isort ## format code with black and isort

##@ Lint

lint-black: ## check code formatting with black
	@black --check --diff .

lint-flake8: ## check code style with flake8
	@flake8 .

lint-isort: ## check import sorting with isort
	@isort --check-only --diff .

lint-mypy: ## check types with mypy
	@mypy --config-file pyproject.toml .

lint-mypy-reports: ## generate an HTML report of the type (mypy) checker
	@mypy --config-file pyproject.toml . --html-report ./tests/mypy-report

lint: lint-black lint-flake8 lint-isort ## check code style with flake8, black, and isort

##@ Tests

tests: ## run tests with pytest
	@pytest --doctest-modules

tests-cov: ## run tests with pytest and generate a coverage report
	@pytest --cov=src --cov-report=xml

tests-cov-fail: ## run tests with pytest and generate a coverage report, fail if coverage is below 50%
	@pytest --cov=src --cov-report=xml --cov-fail-under=50 --junitxml=tests/pytest.xml | tee tests/pytest-coverage.txt

##@ Book

book-build: venv install-book ## build the book
	@uv run jupyter-book build book

book-build-all: venv install-book ## build the book with all outputs
	@uv run jupyter-book build book --all

book-publish: venv install-book install-ghp-import ## publish the book
	@ghp-import -n -p -f book/_build/html

install-ghp-import: install-pipx ## install ghp-import
	@command -v ghp-import &> /dev/null || pipx install ghp-import || true

##@ Install

venv: install-uv ## create virtual environment if it doesn't exist
	@if [ ! -d ".venv" ]; then \
		echo "Creating virtual environment..."; \
		uv venv; \
	fi

install: install-uv venv ## install dependencies
	@uv pip install -e .

install-dev: install-uv venv ## install dev dependencies
	@uv pip install -e ".[dev]"

install-book: install-uv venv ## install book dependencies
	@uv pip install -e ".[book]"

install-all: install-uv venv ## install all dependencies (dev and book)
	@uv pip install -e ".[dev,book]"

update: install-uv venv ## update dependencies
	@uv pip install --upgrade -e ".[dev,book]"

lock: install-uv ## lock dependencies (uv sync creates uv.lock)
	@uv lock

##@ Setup

install-pipx: ## install pipx (pre-requisite for external tools)
	@command -v pipx &> /dev/null || pip install --user pipx || true

install-copier: install-pipx ## install copier (pre-requisite for init-project)
	@command -v copier &> /dev/null || pipx install copier || true

install-uv: install-pipx ## install uv (pre-requisite for install)
	@command -v uv &> /dev/null || pipx install uv || true

install-commitzen: install-pipx ## install commitzen (pre-requisite for commit)
	@command -v cz &> /dev/null || pipx install commitizen || true

install-precommit: install-pipx ## install pre-commit
	@command -v pre-commit &> /dev/null || pipx install pre-commit || true

install-precommit-hooks: install-precommit ## install pre-commit hooks
	@pre-commit install

initialize: install-pipx ## initialize the project environment
	@pipx install copier
	@pipx install uv
	@pipx install commitizen
	@pipx install pre-commit
	@pre-commit install

remove-template: ## remove template-specific files
	@rm -rf src/coursetemp
	@rm -rf tests/coursetemp
	@rm -rf CHANGELOG.md
	@echo "Template-specific files removed."

init-project: initialize remove-template ## initialize the project (Warning: do this only once!)
	@copier copy --trust --answers-file .copier-config.yaml gh:entelecheia/hyperfast-python-template .

reinit-project: install-copier ## reinitialize the project (Warning: this may overwrite existing files!)
	@bash -c 'args=(); while IFS= read -r file; do args+=("--skip" "$$file"); done < .copierignore; copier copy --trust "$${args[@]}" --answers-file .copier-config.yaml gh:entelecheia/hyperfast-python-template .'
