import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_create_task():
    response = client.post(
        "/tasks",
        json={"title": "Test Task", "description": "testing", "completed": False}
    )
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == "Test Task"
    assert data["completed"] is False

def test_list_tasks():
    # Ensure at least one task exists
    client.post("/tasks", json={"title": "List Task", "completed": False})
    
    response = client.get("/tasks")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) >= 1

def test_get_task_by_id():
    # Create a task first
    create_resp = client.post("/tasks", json={"title": "Fetch Task"})
    task_id = create_resp.json()["id"]

    # Fetch the same task
    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == task_id
    assert data["title"] == "Fetch Task"
