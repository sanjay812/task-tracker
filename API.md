#  Task Tracker API

A production-ready FastAPI application for task management with PostgreSQL database, OpenTelemetry observability, and Prometheus metrics.

[![FastAPI](https://img.shields.io/badge/FastAPI-0.104.1-009688.svg?style=flat&logo=FastAPI&logoColor=white)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB.svg?style=flat&logo=python&logoColor=white)](https://www.python.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791.svg?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-Enabled-blue.svg)](https://opentelemetry.io)

## ✨ Features

-  **CRUD Operations** - Create, Read, List, and Delete tasks
-  **PostgreSQL Database** - Reliable data persistence with SQLAlchemy
-  **OpenTelemetry Integration** - Distributed tracing, logging, and metrics
-  **Prometheus Metrics** - Monitor request counts and latencies
-  **Async Operations** - High-performance async/await support
-  **Auto-generated API Docs** - Interactive Swagger UI and ReDoc
-  **Docker Ready** - Containerized deployment support
-  **CI/CD Ready** - GitHub Actions workflow included

##  Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Documentation](#api-documentation)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [Docker Deployment](#docker-deployment)
- [Observability](#observability)
- [Environment Variables](#environment-variables)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- **Python 3.11+**
- **PostgreSQL 15+**
- **Docker** (optional, for containerized setup)
- **OpenTelemetry Collector** (optional, for full observability)

##  Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/task-tracker-api.git
cd task-tracker-api
```

### 2. Create Virtual Environment

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Linux/Mac:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 4. Set Up PostgreSQL

#### Using Docker (Recommended)

```bash
docker run --name postgres-db \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=postgres \
  -p 5432:5432 \
  -d postgres:15
```

#### Or Install Locally

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib

# macOS
brew install postgresql@15

# Start PostgreSQL service
sudo systemctl start postgresql  # Linux
brew services start postgresql@15  # macOS
```

##  Quick Start

### Method 1: Direct Python

```bash
python main.py
```

### Method 2: Using Uvicorn

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Method 3: Using Docker Compose

```bash
docker-compose up --build
```

The API will be available at: **http://localhost:8000**

##  API Documentation

Once the application is running, visit:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Prometheus Metrics**: http://localhost:8000/metrics

##  API Endpoints

### **Create a Task**

**POST** `/tasks`

Creates a new task in the database.

**Request Body:**
```json
{
  "title": "Buy groceries",
  "description": "Milk, eggs, and bread",
  "completed": false
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "title": "Buy groceries",
  "description": "Milk, eggs, and bread",
  "completed": false,
  "created_at": "2025-10-02T10:30:00.000Z",
  "updated_at": "2025-10-02T10:30:00.000Z"
}
```

**cURL Example:**
```bash
curl -X POST "http://localhost:8000/tasks" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries",
    "description": "Milk, eggs, and bread",
    "completed": false
  }'
```

---

### **List All Tasks**

**GET** `/tasks`

Retrieves all tasks, optionally filtered by completion status.

**Query Parameters:**
- `completed` (optional): `true` | `false` - Filter by completion status

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "description": "Milk, eggs, and bread",
    "completed": false,
    "created_at": "2025-10-02T10:30:00.000Z",
    "updated_at": "2025-10-02T10:30:00.000Z"
  }
]
```

**cURL Examples:**
```bash
# Get all tasks
curl -X GET "http://localhost:8000/tasks"

# Get only completed tasks
curl -X GET "http://localhost:8000/tasks?completed=true"

# Get only incomplete tasks
curl -X GET "http://localhost:8000/tasks?completed=false"
```

---

### **Get a Specific Task**

**GET** `/tasks/{task_id}`

Retrieves a single task by ID.

**Path Parameters:**
- `task_id` (required): Integer - Task ID

**Response:** `200 OK`
```json
{
  "id": 1,
  "title": "Buy groceries",
  "description": "Milk, eggs, and bread",
  "completed": false,
  "created_at": "2025-10-02T10:30:00.000Z",
  "updated_at": "2025-10-02T10:30:00.000Z"
}
```

**Error Response:** `404 Not Found`
```json
{
  "detail": "Task not found"
}
```

**cURL Example:**
```bash
curl -X GET "http://localhost:8000/tasks/1"
```

---

### **Delete All Tasks**

**DELETE** `/tasks`

Deletes all tasks and resets the ID sequence.

**Response:** `204 No Content`

**cURL Example:**
```bash
curl -X DELETE "http://localhost:8000/tasks"
```

---

### **Prometheus Metrics**

**GET** `/metrics`

Exposes Prometheus-formatted metrics.

**Response:** `200 OK` (Plain text)
```
# HELP http_requests_total Total HTTP Requests
# TYPE http_requests_total counter
http_requests_total{endpoint="/tasks",http_status="200",method="GET"} 15.0

# HELP http_request_duration_seconds HTTP Request latency in seconds
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{endpoint="/tasks",le="0.005",method="POST"} 8.0
```

**cURL Example:**
```bash
curl -X GET "http://localhost:8000/metrics"
```

## 🧪 Testing

### Complete Testing Workflow

```bash
# 1. Create multiple tasks
curl -X POST "http://localhost:8000/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 1", "description": "First task", "completed": false}'

curl -X POST "http://localhost:8000/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 2", "description": "Second task", "completed": true}'

curl -X POST "http://localhost:8000/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 3", "description": "Third task", "completed": false}'

# 2. List all tasks
curl -X GET "http://localhost:8000/tasks"

# 3. Filter completed tasks
curl -X GET "http://localhost:8000/tasks?completed=true"

# 4. Get specific task
curl -X GET "http://localhost:8000/tasks/1"

# 5. Check metrics
curl -X GET "http://localhost:8000/metrics"

# 6. Delete all tasks
curl -X DELETE "http://localhost:8000/tasks"

# 7. Verify deletion
curl -X GET "http://localhost:8000/tasks"
```

### Using Python Requests

```python
import requests

BASE_URL = "http://localhost:8000"

# Create a task
response = requests.post(f"{BASE_URL}/tasks", json={
    "title": "Learn FastAPI",
    "description": "Complete the tutorial",
    "completed": False
})
print(response.json())

# List all tasks
response = requests.get(f"{BASE_URL}/tasks")
print(response.json())

# Get specific task
response = requests.get(f"{BASE_URL}/tasks/1")
print(response.json())

# Delete all tasks
response = requests.delete(f"{BASE_URL}/tasks")
print(response.status_code)
```

### Using Postman

1. Import the following collection or create requests manually
2. Set base URL: `http://localhost:8000`

**Create Task:**
- Method: `POST`
- URL: `{{base_url}}/tasks`
- Headers: `Content-Type: application/json`
- Body (raw JSON):
```json
{
  "title": "Complete project",
  "description": "Finish the FastAPI project",
  "completed": false
}
```

##  Docker Deployment

### Using Docker Compose (Recommended)

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  otel-collector:
    image: otel/opentelemetry-collector:latest
    command: ["--config=/etc/otel-collector-config.yml"]
    volumes:
      - ./otel-collector-config.yml:/etc/otel-collector-config.yml
    ports:
      - "4317:4317"
      - "4318:4318"

  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://postgres:password@postgres:5432/postgres
    depends_on:
      postgres:
        condition: service_healthy
      otel-collector:
        condition: service_started

volumes:
  postgres_data:
```

**Run:**
```bash
docker-compose up --build
```

### Using Docker Only

```bash
# Build image
docker build -t task-tracker-api .

# Run container
docker run -d \
  --name task-tracker \
  -p 8000:8000 \
  -e DATABASE_URL="postgresql://postgres:password@host.docker.internal:5432/postgres" \
  task-tracker-api
```

##  Observability

### OpenTelemetry Traces

The application creates distributed traces for:
- `create_task` - Task creation operations
- `list_tasks` - Task listing operations
- `get_task_by_id` - Single task retrieval
- `delete_all_tasks` - Bulk delete operations

### Structured Logging

All operations are logged with structured information:
```
2025-10-02 10:30:00 - INFO - Creating task with data: title=Buy groceries, description=Milk, eggs, and bread, completed=False
2025-10-02 10:30:15 - INFO - Fetched 3 tasks
2025-10-02 10:30:20 - WARNING - Task not found with id: 99
```

### Prometheus Metrics

**Available Metrics:**
- `http_requests_total` - Counter of HTTP requests by method, endpoint, and status
- `http_request_duration_seconds` - Histogram of request latencies

**Grafana Dashboard:**

Query examples:
```promql
# Request rate
rate(http_requests_total[5m])

# 95th percentile latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Error rate
rate(http_requests_total{http_status=~"5.."}[5m])
```

##  Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://postgres:password@localhost:5432/postgres` |
| `OTEL_ENDPOINT` | OpenTelemetry collector endpoint | `http://otel-collector:4317` |

**Setting Environment Variables:**

```bash
# Linux/Mac
export DATABASE_URL="postgresql://user:pass@host:5432/dbname"

# Windows (CMD)
set DATABASE_URL=postgresql://user:pass@host:5432/dbname

# Windows (PowerShell)
$env:DATABASE_URL="postgresql://user:pass@host:5432/dbname"

# Using .env file
echo 'DATABASE_URL="postgresql://user:pass@host:5432/dbname"' > .env
```

##  Project Structure

```
task-tracker-api/
├── .github/
│   └── workflows/
│       └── deployment.yml      # GitHub Actions workflow
├── main.py                     # FastAPI application
├── requirements.txt            # Python dependencies
├── Dockerfile                  # Docker configuration
├── yml
    └── docker-compose.yml      # Docker Compose setup
├── .env.example               # Environment variables template
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## 🛠️ Development

### Running Tests

```bash
# Install test dependencies
pip install pytest pytest-asyncio httpx

# Run tests
pytest tests/ -v

# Run with coverage
pytest --cov=. tests/
```

### Code Quality

```bash
# Format code
black .

# Sort imports
isort .

# Lint code
flake8 . --max-line-length=120
```

##  Production Deployment

### Health Checks

The application includes a Docker health check. For Kubernetes:

```yaml
livenessProbe:
  httpGet:
    path: /tasks
    port: 8000
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /tasks
    port: 8000
  initialDelaySeconds: 5
  periodSeconds: 5
```

### Performance Tips

1. **Use connection pooling** - Already configured in SQLAlchemy
2. **Enable Uvicorn workers** for production:
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
   ```
3. **Use a reverse proxy** - Nginx or Traefik
4. **Configure database connection limits**

##  Troubleshooting

### Database Connection Issues

```bash
# Check PostgreSQL is running
docker ps | grep postgres

# Test connection
psql -h localhost -U postgres -d postgres

# Check logs
docker logs postgres-db
```

### Port Already in Use

```bash
# Find process using port 8000
lsof -i :8000  # Mac/Linux
netstat -ano | findstr :8000  # Windows

# Kill process or use different port
uvicorn main:app --port 8001
```

### OpenTelemetry Collector Errors

The application will continue to work even if the OTLP collector is unavailable. To disable OTLP exports, comment out the exporter configuration in `main.py`.
