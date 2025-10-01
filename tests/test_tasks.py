import os
import pytest
from fastapi.testclient import TestClient
from main import app, database, metadata, DATABASE_URL
from sqlalchemy import create_engine

# -----------------------------
# Setup DATABASE_URL for tests
# -----------------------------
os.environ["DATABASE_URL"] = os.getenv("DATABASE_URL")

# Create tables if they don't exist
engine = create_engine(DATABASE_URL)
metadata.create_all(engine)

# -----------------------------
# Test client fixture
# -----------------------------
@pytest.fixture(scope="module")
def client():
    """
    TestClient with FastAPI startup/shutdown events.
    Ensures the database connection is acquired for tests.
    """
    with TestClient(app) as c:
        yield c

# -----------------------------
# Tests
# -----------------------------
def test_create_task(client):
    response = client.post("/tasks", json={"title": "Test Task", "description": "Test description"})
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == "Test Task"
    assert data["description"] == "Test description"
    assert data["completed"] is False
    assert "id" in data

def test_list_tasks(client):
    response = client.get("/tasks")
    assert response.status_code == 200
    tasks = response.json()
    assert isinstance(tasks, list)
    assert any(task["title"] == "Test Task" for task in tasks)

def test_get_task(client):
    # First, create a task
    response = client.post("/tasks", json={"title": "Another Task"})
    task_id = response.json()["id"]

    # Fetch the task
    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == task_id
    assert data["title"] == "Another Task"
