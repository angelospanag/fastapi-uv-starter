FROM ghcr.io/astral-sh/uv:python3.14-trixie-slim AS builder
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
