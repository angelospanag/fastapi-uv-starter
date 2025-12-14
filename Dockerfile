FROM ghcr.io/astral-sh/uv:python3.14-trixie-slim AS builder

# Install build dependencies for Rust extensions
RUN apt-get update && apt-get install -y --no-install-recommends build-essential curl

WORKDIR /app

COPY pyproject.toml uv.lock* ./

RUN uv sync --frozen --no-dev

COPY app/ app/

FROM python:3.14-slim AS runtime

COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app
COPY --from=builder /app /app

EXPOSE 80

CMD ["fastapi", "run", "app/main.py", "--port", "80", "--host", "0.0.0.0"]
