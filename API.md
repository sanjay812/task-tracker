#  Task Tracker API

A production-ready FastAPI application for task management with PostgreSQL database, OpenTelemetry observability, and Prometheus metrics.

[![FastAPI](https://img.shields.io/badge/FastAPI-0.104.1-009688.svg?style=flat&logo=FastAPI&logoColor=white)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB.svg?style=flat&logo=python&logoColor=white)](https://www.python.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791.svg?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-Enabled-blue.svg)](https://opentelemetry.io)

##  Features

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

- **Prometheus Metrics**: http://localhost:8000/metrics

# Accessing the Task Tracker API on EC2

## Public Access via EC2 Instance

The application is deployed on AWS EC2 and accessible through a public IP with Nginx as a reverse proxy.

### Base URLs

| Environment | URL | Notes |
|-------------|-----|-------|
| **EC2 Production** | `http://13.203.213.97/api` | Behind Nginx proxy |
| **Local Development** | `http://localhost:8000` | Direct access |

---

## 🌐 API Endpoints (EC2 Production)

### **Create a Task**

```bash
curl -X POST "http://13.203.213.97/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries",
    "description": "Milk, eggs, and bread",
    "completed": false
  }'
```

### **List All Tasks**

```bash
# Get all tasks
curl -X GET "http://13.203.213.97/api/tasks"

# Get completed tasks only
curl -X GET "http://13.203.213.97/api/tasks?completed=true"

# Get incomplete tasks only
curl -X GET "http://13.203.213.97/api/tasks?completed=false"
```

### **Get a Specific Task**

```bash
curl -X GET "http://13.203.213.97/api/tasks/1"
```

### **Delete All Tasks**

```bash
curl -X DELETE "http://13.203.213.97/api/tasks"
```

### **Prometheus Metrics**

```bash
curl -X GET "http://13.203.213.97/api/metrics"
```

---

## 📚 API Documentation

Access the interactive API documentation:

- **Swagger UI**: http://13.203.213.97/api/docs
- **ReDoc**: http://13.203.213.97/api/redoc

---

## 🐍 Python Client Example (EC2)

```python
import requests

# EC2 Base URL
BASE_URL = "http://13.203.213.97/api"

# Create a task
response = requests.post(f"{BASE_URL}/tasks", json={
    "title": "Learn FastAPI",
    "description": "Complete the tutorial",
    "completed": False
})
print("Created:", response.json())

# List all tasks
response = requests.get(f"{BASE_URL}/tasks")
print("All tasks:", response.json())

# Get specific task
task_id = 1
response = requests.get(f"{BASE_URL}/tasks/{task_id}")
print(f"Task {task_id}:", response.json())

# Filter completed tasks
response = requests.get(f"{BASE_URL}/tasks", params={"completed": True})
print("Completed tasks:", response.json())

# Delete all tasks
response = requests.delete(f"{BASE_URL}/tasks")
print("Delete status:", response.status_code)
```

---

## 🧪 Complete Testing Workflow (EC2)

```bash
# 1. Create multiple tasks
curl -X POST "http://13.203.213.97/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 1", "description": "First task", "completed": false}'

curl -X POST "http://13.203.213.97/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 2", "description": "Second task", "completed": true}'

curl -X POST "http://13.203.213.97/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 3", "description": "Third task", "completed": false}'

# 2. List all tasks
curl -X GET "http://13.203.213.97/api/tasks"

# 3. Filter completed tasks
curl -X GET "http://13.203.213.97/api/tasks?completed=true"

# 4. Get specific task
curl -X GET "http://13.203.213.97/api/tasks/1"

# 5. Check metrics
curl -X GET "http://13.203.213.97/api/metrics"

# 6. Delete all tasks
curl -X DELETE "http://13.203.213.97/api/tasks"

# 7. Verify deletion
curl -X GET "http://13.203.213.97/api/tasks"
```

---

## ⚙️ Nginx Configuration

The EC2 instance uses Nginx as a reverse proxy with the following configuration:

```nginx
server {
    listen 80;
    server_name 13.203.213.97;

    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Key Points:**
- All requests to `/api/*` are proxied to `http://localhost:8000/`
- The `/api` prefix is stripped before forwarding to FastAPI
- Original client IP and protocol information is preserved in headers

---

## 🔒 Security Considerations

### Current Setup
- ⚠️ Using HTTP (not HTTPS) - suitable for development/testing only
- Public IP directly exposed
- No authentication/authorization implemented

### Production Recommendations
1. **Enable HTTPS** with Let's Encrypt SSL certificate
2. **Use a domain name** instead of IP address
3. **Implement authentication** (OAuth2, JWT)
4. **Add rate limiting** in Nginx
5. **Configure security headers**
6. **Use AWS Security Groups** to restrict access

---

## 🔄 Switching Between Environments

### Environment-Aware Client

```python
import os
import requests

# Automatically detect environment
ENVIRONMENT = os.getenv("APP_ENV", "local")

BASE_URLS = {
    "local": "http://localhost:8000",
    "production": "http://13.203.213.97/api"
}

BASE_URL = BASE_URLS.get(ENVIRONMENT, BASE_URLS["local"])

# Use BASE_URL for all requests
response = requests.get(f"{BASE_URL}/tasks")
print(response.json())
```

### Bash Script

```bash
#!/bin/bash

# Set environment
ENV=${1:-local}

if [ "$ENV" = "production" ]; then
    BASE_URL="http://13.203.213.97/api"
else
    BASE_URL="http://localhost:8000"
fi

echo "Using environment: $ENV"
echo "Base URL: $BASE_URL"

# Create a task
curl -X POST "$BASE_URL/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Task", "description": "Testing", "completed": false}'

# List tasks
curl -X GET "$BASE_URL/tasks"
```

**Usage:**
```bash
# Local
./test.sh local

# Production
./test.sh production
```

---

## 📊 Monitoring EC2 Deployment

### Check Application Status

```bash
# SSH into EC2 instance
ssh -i your-key.pem ubuntu@13.203.213.97

# Check if application is running
ps aux | grep uvicorn

# Check application logs
journalctl -u task-tracker -f

# Check Nginx status
sudo systemctl status nginx

# Check Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Health Check

```bash
# Simple health check
curl -I http://13.203.213.97/api/tasks

# Expected response
HTTP/1.1 200 OK
Content-Type: application/json
```

---

## 🚀 Deployment Architecture

```
Internet
    ↓
AWS EC2 (13.203.213.97)
    ↓
Nginx (:80) - Reverse Proxy
    ↓
FastAPI (:8000) - Application
    ↓
PostgreSQL (:5432) - Database
```

**Request Flow:**
1. Client sends request to `http://13.203.213.97/api/tasks`
2. Nginx receives request on port 80
3. Nginx strips `/api` prefix and forwards to FastAPI on `localhost:8000/tasks`
4. FastAPI processes request and queries PostgreSQL
5. Response flows back through Nginx to client

---

## 📱 Postman Configuration

**Environment Variables:**

| Variable | Local Value | Production Value |
|----------|-------------|------------------|
| `base_url` | `http://localhost:8000` | `http://13.203.213.97/api` |

**Collection Setup:**
1. Create requests using `{{base_url}}/tasks`
2. Switch environments to test local vs production
3. No other changes needed

---

## 🐛 Troubleshooting EC2 Deployment

### Cannot Connect to EC2

```bash
# Check AWS Security Group allows port 80
# Inbound rules should include:
# Type: HTTP, Port: 80, Source: 0.0.0.0/0

# Test connectivity
ping 13.203.213.97
telnet 13.203.213.97 80
```

### 502 Bad Gateway

```bash
# Check if FastAPI is running
curl http://localhost:8000/tasks

# If not running, start the application
# (SSH into EC2 first)
```

### 404 Not Found

Ensure you're using the `/api` prefix:
- ✅ Correct: `http://13.203.213.97/api/tasks`
- ❌ Wrong: `http://13.203.213.97/tasks`


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
