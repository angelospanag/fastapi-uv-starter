from http import HTTPStatus

import pytest
from fastapi.testclient import TestClient
from structlog.testing import capture_logs

from app.main import app


@pytest.fixture()
def client():
    with TestClient(app) as c:
        yield c


def test_healthcheck(client):
    response = client.get("/healthcheck")
    assert response.status_code == HTTPStatus.OK
    assert response.text == ""


def test_read_main(client):
    # Example of testing logging using a context manager
    with capture_logs() as cap_logs:
        response = client.get("/")
        assert {"event": "In root path", "log_level": "info"} in cap_logs
        assert {"event": "OK", "log_level": "info"} in cap_logs
        assert response.status_code == HTTPStatus.OK
        assert response.json() == {"msg": "Hello World"}
