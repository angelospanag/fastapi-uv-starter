# fastapi-uv-starter

A starter project using Python, FastAPI and uv.

<!-- TOC -->
- [fastapi-uv-starter](#fastapi-uv-starter)
  - [Description](#description)
  - [Getting Started](#getting-started)
  - [Development](#development)
  - [Containerisation](#containerisation)
    - [1. Build image and tag it as `fastapi-uv-starter`](#1-build-image-and-tag-it-as-fastapi-uv-starter)
    - [2. Run a container of the previously tagged image (`fastapi-uv-starter`)](#2-run-a-container-of-the-previously-tagged-image-fastapi-uv-starter)
    - [3. Check running containers](#3-check-running-containers)
    - [4. Hit sample endpoint](#4-hit-sample-endpoint)
<!-- TOC -->

## Description

A project starter for personal usage containing the following:

- [Python 3.14.\*](https://www.python.org/)
- [FastAPI](https://fastapi.tiangolo.com/) web framework
- Structured logging using [`structlog`](https://www.structlog.org/)
- Dependency management using [`uv`](https://docs.astral.sh/uv/)
- Toolchain management using [`mise`](https://mise.jdx.dev/)
- Containerisation using a Dockerfile
- Testing with [`pytest`](https://docs.pytest.org/) and optionally with coverage
  with [`pytest-cov`](https://pytest-cov.readthedocs.io/)
- Linting/formatting using [`Ruff`](https://docs.astral.sh/ruff/)
- Type checking using [`ty`](https://github.com/astral-sh/ty)
- [`.gitignore`](https://github.com/github/gitignore/blob/main/Python.gitignore)

## Getting Started

[`mise`](https://mise.jdx.dev/) manages the pinned toolchain (Python 3.14.7, uv 0.12.5).

**macOS / Linux**

```bash
curl https://mise.run | sh
```

**Windows**

```bash
winget install jdx.mise
```

Activate mise in your shell so the pinned versions take precedence over any system installs (Homebrew, etc.). In `~/.zshrc`:

```bash
eval "$(mise activate zsh)"
```

Then, in the repo:

```bash
mise trust        # one-time, confirms you trust this repo's mise.toml
mise install      # downloads and pins Python and uv
mise run install  # installs dependencies into .venv
```

## Development

| Command              | Description                          |
| -------------------- | ------------------------------------ |
| `mise run install`   | Install dependencies into `.venv`    |
| `mise run dev`       | FastAPI dev server on 127.0.0.1:8000 |
| `mise run serve`     | Production server on 0.0.0.0:8000    |
| `mise run test`      | Run tests with coverage              |
| `mise run fmt`       | Format code via `ruff format`        |
| `mise run lint`      | Lint code via `ruff check`           |
| `mise run typecheck` | Type check via `ty check`            |
| `mise run vuln`      | Audit deps for known vulnerabilities |
| `mise run deps`      | Update and sync dependencies         |

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
