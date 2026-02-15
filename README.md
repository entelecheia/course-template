# Course Template


[![halla-img]][halla-url]
[![course-img]][course-url]
[![lecture-img]][lecture-url]
[![version-image]][release-url]
[![release-date-image]][release-url]
[![license-image]][license-url]
[![codecov][codecov-image]][codecov-url]
[![jupyter-book-image]][docs-url]

<!-- Links: -->
[halla-img]: https://img.shields.io/badge/CHU-halla.ai-blue
[halla-url]: https://halla.ai
[course-img]: https://img.shields.io/badge/course-entelecheia.ai-blue
[course-url]: https://course.entelecheia.ai
[lecture-img]: https://img.shields.io/badge/lecture-entelecheia.ai-blue
[lecture-url]: https://lecture.entelecheia.ai

[codecov-image]: https://codecov.io/gh/entelecheia/course-template/branch/main/graph/badge.svg?token=qlsfdVYveD
[codecov-url]: https://codecov.io/gh/entelecheia/course-template
[pypi-image]: https://img.shields.io/pypi/v/course-template
[license-image]: https://img.shields.io/github/license/entelecheia/course-template
[license-url]: https://github.com/entelecheia/course-template/blob/main/LICENSE
[version-image]: https://img.shields.io/github/v/release/entelecheia/course-template?sort=semver
[release-date-image]: https://img.shields.io/github/release-date/entelecheia/course-template
[release-url]: https://github.com/entelecheia/course-template/releases
[jupyter-book-image]: https://jupyterbook.org/en/stable/_images/badge.svg

[repo-url]: https://github.com/entelecheia/course-template
[pypi-url]: https://pypi.org/project/course-template
[docs-url]: https://entelecheia.github.io/course-template
[changelog]: https://github.com/entelecheia/course-template/blob/main/CHANGELOG.md
[contributing guidelines]: https://github.com/entelecheia/course-template/blob/main/CONTRIBUTING.md
<!-- Links: -->

Streamlined course creation template with interactive documentation support

- Documentation: [https://entelecheia.github.io/course-template][docs-url]
- GitHub: [https://github.com/entelecheia/course-template][repo-url]
- PyPI: [https://pypi.org/project/course-template][pypi-url]

This project provides a comprehensive and flexible template for creating and managing online courses, leveraging GitHub for version control and Jupyter Book for interactive content delivery, enabling educators to easily develop, maintain, and share their educational materials.

## Overview

Course Template is built on the [Hyperfast Python Template](https://github.com/entelecheia/hyperfast-python-template) and combines a Python package scaffold with a Jupyter Book–based documentation site. It gives you everything you need to go from an empty repository to a published, interactive course website with minimal setup.

The template is designed around two core ideas. First, course content lives alongside code — lecture notes, syllabi, and about pages are written in MyST Markdown inside the `book/` directory, while reusable Python utilities live in `src/coursetemp/`. Second, automation is built in from the start — a single `Makefile` exposes commands for installing dependencies, running tests, formatting code, and building or publishing the book site.

### Key Features

- **Interactive Jupyter Book site** — Write lecture notes in MyST Markdown with support for live code cells (via Thebe/Binder), math, figures, cross-references, and a rich set of Sphinx extensions (tabs, proofs, hover references, YouTube/video embeds, Mermaid diagrams, and more).
- **Python package scaffold** — The `src/coursetemp/` package ships a CLI (`coursetemp`) built with Click, ready to be extended with course-specific tooling.
- **Modern dependency management** — Uses [uv](https://docs.astral.sh/uv/) for fast, reproducible installs with optional dependency groups for development (`dev`) and documentation (`book`).
- **Quality toolchain** — Pre-configured Black, isort, Flake8, mypy, and pytest so every commit stays formatted, linted, type-checked, and tested.
- **One-command publishing** — `make book-publish` deploys the built site to GitHub Pages via `ghp-import`.
- **Semantic versioning & releases** — Integrated with `python-semantic-release` and Commitizen for automated changelogs, tags, and PyPI uploads.
- **Open license** — Ships under CC-BY-4.0, encouraging reuse and remixing of educational content.

## Project Structure

```
course-template/
├── book/                  # Jupyter Book content
│   ├── myst.yml           # Book configuration (title, TOC, site options)
│   ├── index.md           # Landing page
│   ├── week01/            # Weekly lecture notes
│   │   ├── index.md
│   │   ├── session1.md
│   │   └── session2.md
│   ├── syllabus/          # Course syllabus
│   ├── about/             # About page
│   ├── _static/           # Static assets (images, CSS)
│   └── references.bib     # Bibliography
├── src/coursetemp/        # Python package source
│   ├── __init__.py
│   ├── __cli__.py         # Click-based CLI entry point
│   ├── _version.py        # Version string
│   └── conf/              # Configuration files
├── tests/                 # Test suite (pytest)
├── pyproject.toml         # Project metadata & tool configuration
├── Makefile               # Build, lint, test, and publish commands
├── uv.lock                # Locked dependency versions
└── ...
```

## Requirements

- Python 3.9 – 3.12
- [uv](https://docs.astral.sh/uv/) (dependency management)

## Installation

```bash
# Install base dependencies
make install

# Install with dev tools (linting, testing, type-checking)
make install-dev

# Install with book/docs dependencies
make install-book

# Install everything
make install-all
```

## Usage

```bash
# Run the CLI
coursetemp --name "World" --count 2
```

## Development

```bash
# Format code
make format

# Run linters (black, flake8, isort)
make lint

# Run type checker
make lint-mypy

# Run tests
make tests

# Run tests with coverage (fails below 50%)
make tests-cov-fail
```

## Building the Book

```bash
make book-build    # Build HTML
make book-start    # Preview server
make book-publish  # Deploy to GitHub Pages
```

## Customizing for Your Course

1. **Edit `book/myst.yml`** — Update the project title, author name, copyright year, and GitHub repository URL to match your course.
2. **Add lecture content** — Create new weekly directories under `book/` (e.g., `week02/`, `week03/`) with MyST Markdown files for each session. Register them in the `toc` section of `myst.yml`.
3. **Update the syllabus** — Edit `book/syllabus/index.md` with your course schedule, objectives, and grading policy.
4. **Extend the Python package** — Add course-specific utilities, data loaders, or grading scripts under `src/coursetemp/`. The CLI in `__cli__.py` can be expanded with new commands.
5. **Rename the package** — If you want a different package name, update the `name` field in `pyproject.toml`, rename the `src/coursetemp/` directory, and adjust the `[project.scripts]` entry point accordingly.
6. **Configure the site** — Customize favicon, analytics, and theme options in the `site` section of `book/myst.yml`.

## Changelog

See the [CHANGELOG] for more information.

## Contributing

Contributions are welcome! Please see the [contributing guidelines] for more information.

## License

This project is released under the [CC-BY-4.0 License][license-url].
