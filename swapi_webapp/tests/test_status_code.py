import pytest
from app import app

def test_movies_status_code():

    test_client = app.test_client()
    response = test_client.get("/movies")
    assert response.status_code == 200
