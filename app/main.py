import uuid

import structlog
from fastapi import FastAPI, Request, Response

app = FastAPI()
logger = structlog.get_logger()

EXCLUDED_PATHS = {"/healthcheck"}


@app.middleware("http")
async def logger_middleware(request: Request, call_next):
    structlog.contextvars.clear_contextvars()
    structlog.contextvars.bind_contextvars(
        path=request.url.path,
        method=request.method,
        client_host=request.client.host if request.client else None,
        request_id=str(uuid.uuid7()),
    )
    response = await call_next(request)

    structlog.contextvars.bind_contextvars(
        status_code=response.status_code,
    )

    if request.url.path not in EXCLUDED_PATHS:
        if 400 <= response.status_code < 500:
            logger.warning("Client error")
        elif response.status_code >= 500:
            logger.error("Server error")
        else:
            logger.info("OK")

    return response


@app.get("/healthcheck")
async def healthcheck():
    return Response()


@app.get("/")
async def read_main():
    logger.info("In root path")
    return {"msg": "Hello World"}
