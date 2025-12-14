# fastapi-uv-starter

A starter project using Python, FastAPI and uv.

<!-- TOC -->
* [fastapi-uv-starter](#fastapi-uv-starter)
  * [Description](#description)
  * [Prerequisites](#prerequisites)
    * [1. Install Python 3 and uv](#1-install-python-3-and-uv)
    * [2. Create a virtual environment with all necessary dependencies](#2-create-a-virtual-environment-with-all-necessary-dependencies)
  * [Run application](#run-application)
    * [Development mode](#development-mode)
    * [Production mode](#production-mode)
  * [Testing](#testing)
    * [With coverage](#with-coverage)
    * [With coverage and HTML output](#with-coverage-and-html-output)
  * [Linting](#linting)
  * [Formatting](#formatting)
  * [Containerisation](#containerisation)
    * [1. Build image and tag it as `fastapi-uv-starter`](#1-build-image-and-tag-it-as-fastapi-uv-starter)
    * [2. Run a container of the previously tagged image (`fastapi-uv-starter`)](#2-run-a-container-of-the-previously-tagged-image-fastapi-uv-starter)
    * [3. Check running containers](#3-check-running-containers)
    * [4. Hit sample endpoint](#4-hit-sample-endpoint)
<!-- TOC -->

## Description

A project starter for personal usage containing the following:

- [Python 3.14.\*](https://www.python.org/)
- [FastAPI](https://fastapi.tiangolo.com/) web framework
- Structured logging using [`structlog`](https://www.structlog.org/)
- Dependency management using [`uv`](https://docs.astral.sh/uv/)
- Containerisation using a Dockerfile
- Testing with [`pytest`](https://docs.pytest.org/) and optionally with coverage
  with [`pytest-cov`](https://pytest-cov.readthedocs.io/)
- Linting/formatting using [`Ruff`](https://docs.astral.sh/ruff/)
- [`.gitignore`](https://github.com/github/gitignore/blob/main/Python.gitignore)

## Prerequisites

- [Python 3.14.\*](https://www.python.org/downloads/)
- [uv](https://docs.astral.sh/uv/)

### 1. Install Python 3 and uv

**MacOS (using `brew`)**

```bash
brew install python@3.14 uv
```

**Ubuntu/Debian**

```bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.14
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Create a virtual environment with all necessary dependencies

From the root of the project execute:

```bash
uv sync
```

## Run application

### Development mode

```bash
uv run fastapi dev
```

### Production mode

```bash
uv run fastapi run
```

## Testing

```bash
uv run pytest
```

### With coverage

```bash
uv run pytest --cov=app
```

### With coverage and HTML output

```bash
uv run pytest --cov-report html --cov=app
```

## Linting

```bash
uv run ruff check app/* tests/*
```

## Formatting

```bash
uv run ruff format app/* tests/*
```

## Containerisation

The following `podman` commands are direct replacements of the Docker CLI. You can see that their syntax is identical:

### 1. Build image and tag it as `fastapi-uv-starter`

```bash
podman image build -t fastapi-uv-starter .
```

### 2. Run a container of the previously tagged image (`fastapi-uv-starter`)

Run our FastAPI application and map our local port `8000` to `80` on the running container:

```bash
podman container run -d --name fastapi-uv-starter -p 8000:80 --network bridge fastapi-uv-starter
```

### 3. Check running containers

```bash
podman ps
```

```bash
CONTAINER ID  IMAGE                            COMMAND               CREATED         STATUS             PORTS                 NAMES
78586e5b4683  localhost/fastapi-uv-starter:latest  uvicorn main:app ...  13 minutes ago  Up 5 minutes ago  0.0.0.0:8000->80/tcp  nifty_roentgen
```

### 4. Hit sample endpoint

Our FastAPI server now runs on port `8000` on our local machine. We can test it with:

```bash
curl -i http://localhost:8000/healthcheck
```

Output:

```bash
HTTP/1.1 200 OK
server: uvicorn
content-length: 0
```
