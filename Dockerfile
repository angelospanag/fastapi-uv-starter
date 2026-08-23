FROM ghcr.io/astral-sh/uv:0.12.5-python3.14-trixie-slim AS builder
WORKDIR /app
COPY pyproject.toml uv.lock* ./
RUN uv sync --frozen --no-dev
COPY app/ app/

FROM python:3.14.7-slim-trixie AS runtime
ENV PATH="/app/.venv/bin:$PATH"
WORKDIR /app
COPY --from=builder /app /app
RUN useradd --no-create-home appuser && chown -R appuser /app
USER appuser
EXPOSE 80
CMD ["fastapi", "run", "app/main.py", "--port", "80", "--host", "0.0.0.0"]
