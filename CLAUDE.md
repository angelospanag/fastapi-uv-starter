# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

All tasks run via `mise run <task>`. The toolchain (Python 3.14.7, uv 0.12.5) is pinned in `mise.toml`.

| Task                | Command              |
| ------------------- | -------------------- |
| Install deps        | `mise run install`   |
| Dev server          | `mise run dev`       |
| Production server   | `mise run serve`     |
| Tests               | `mise run test`      |
| Format              | `mise run fmt`       |
| Lint                | `mise run lint`      |
| Type check          | `mise run typecheck` |
| Vulnerability audit | `mise run vuln`      |
| Upgrade deps        | `mise run deps`      |

Run a single test: `uv run pytest tests/test_main.py::test_healthcheck -v`

## Architecture

`app/__init__.py` runs on import and configures structlog globally (JSON output, disables uvicorn's own loggers). It must be imported before `app/main.py` to ensure logging is set up. The FastAPI `app` object in `app/main.py` imports from this package, so the side-effect fires automatically.

`app/main.py` owns the FastAPI application. The HTTP middleware (`logger_middleware`) handles all request logging: it binds context vars (path, method, client_host, request_id) before calling the next handler, then logs at the appropriate level based on the response status code. `EXCLUDED_PATHS` controls which routes are silenced — add new silent paths there rather than branching in the middleware body. Log context is cleared per-request via `structlog.contextvars`.

## Testing

Tests use a `pytest` fixture that wraps `TestClient` as a context manager — do not instantiate `TestClient` at module level. Use `structlog.testing.capture_logs()` as a context manager to assert on log events emitted during a request; captured events are plain dicts with `event` and `log_level` keys (context vars are not merged by the capture processor).

## Deployment

`deployment.yaml` targets a local Kubernetes cluster (no image registry). To deploy to a real cluster: push the image to a registry, update the `image:` field, and remove or adjust `imagePullPolicy`. Resource limits and liveness/readiness probes hitting `/healthcheck` are already configured.
