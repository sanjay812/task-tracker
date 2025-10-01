from fastapi import FastAPI, HTTPException, Response, Depends
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import databases
import sqlalchemy
import os
import logging
import time
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, DateTime, Boolean
# OpenTelemetry imports
from opentelemetry import trace
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

from opentelemetry._logs import set_logger_provider
from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor
from opentelemetry.exporter.otlp.proto.grpc._log_exporter import OTLPLogExporter

from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST
from prometheus_client import Counter, Histogram

# Create metrics
REQUEST_COUNT = Counter(
    'http_requests_total', 'Total HTTP Requests',
    ['method', 'endpoint', 'http_status']
)

REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds', 'HTTP Request latency in seconds',
    ['method', 'endpoint']
)

resource = Resource.create(attributes={"service.name": "task-tracker"})

# ------- Tracing -------
trace_provider = TracerProvider(resource=resource)
trace_exporter = OTLPSpanExporter(endpoint="http://fastapi-otel-collector-1:4317", insecure=True)
trace_provider.add_span_processor(BatchSpanProcessor(trace_exporter))
trace.set_tracer_provider(trace_provider)
tracer = trace.get_tracer(__name__)

# ------- Logging -------
logger_provider = LoggerProvider(resource=resource)
set_logger_provider(logger_provider)
log_exporter = OTLPLogExporter(endpoint="http://fastapi-otel-collector-1:4317", insecure=True)
logger_provider.add_log_record_processor(BatchLogRecordProcessor(log_exporter))
handler = LoggingHandler(logger_provider=logger_provider)
logging.getLogger().addHandler(handler)
logging.getLogger().setLevel(logging.INFO)
logger = logging.getLogger(__name__)


# Database configuration
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost:5432/postgres")
database = databases.Database(DATABASE_URL)
metadata = MetaData()

# Define tasks table
tasks = Table(
    "tasks",
    metadata,
    Column("id", Integer, primary_key=True, index=True),
    Column("title", String, nullable=False),
    Column("description", String, nullable=True),
    Column("completed", Boolean, default=False),
    Column("created_at", DateTime, default=datetime.utcnow),
    Column("updated_at", DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
)

# Create engine
engine = create_engine(DATABASE_URL)
metadata.create_all(engine)

# Pydantic models
class TaskCreate(BaseModel):
    title: str
    description: Optional[str] = None
    completed: bool = False

class TaskResponse(BaseModel):
    id: int
    title: str
    description: Optional[str]
    completed: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

# FastAPI app
app = FastAPI(title="Task Tracker API")


@app.on_event("startup")
async def startup():
    logger.info("Starting up Task Tracker API")
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    logger.info("Shutting down Task Tracker API")
    await database.disconnect()

@app.post("/tasks", response_model=TaskResponse, status_code=201)
async def create_task(task: TaskCreate):
    with tracer.start_as_current_span("create_task"):
        query = tasks.insert().values(
            title=task.title,
            description=task.description,
            completed=task.completed,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        last_record_id = await database.execute(query)
        
        # Fetch the created task
        select_query = tasks.select().where(tasks.c.id == last_record_id)
        created_task = await database.fetch_one(select_query)
        logger.info(f"Creating task with data: title={task.title}, description={task.description}, completed={task.completed}")
    return created_task

@app.get("/tasks", response_model=List[TaskResponse])
async def list_tasks(completed: Optional[bool] = None):
    with tracer.start_as_current_span("list_tasks"):
        query = tasks.select()
        
        if completed is not None:
            query = query.where(tasks.c.completed == completed)
        
        query = query.order_by(tasks.c.created_at.desc())
        results = await database.fetch_all(query)
        logger.info(f"Fetched {len(results)} tasks")
        for t in results:
            logger.info(f"Task: id={t['id']}, title={t['title']}, completed={t['completed']}")
    return results

@app.get("/tasks/{task_id}", response_model=TaskResponse)
async def get_task(task_id: int):
    with tracer.start_as_current_span("get_task_by_id"):
        query = tasks.select().where(tasks.c.id == task_id)
        task = await database.fetch_one(query)
        
        if not task:
            logger.warning(f"Task not found with id: {task_id}")
            raise HTTPException(status_code=404, detail="Task not found")
        logger.info(f"Fetched task: id={task['id']}, title={task['title']}, description={task['description']}, completed={task['completed']}, created_at={task['created_at']}, updated_at={task['updated_at']}") 
    return task


@app.middleware("http")
async def prometheus_middleware(request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time

    endpoint = request.url.path
    method = request.method
    status_code = response.status_code

    REQUEST_COUNT.labels(method=method, endpoint=endpoint, http_status=status_code).inc()
    REQUEST_LATENCY.labels(method=method, endpoint=endpoint).observe(process_time)

    return response

@app.get("/metrics")
async def metrics():
    # Expose Prometheus metrics
    metrics_data = generate_latest()
    return Response(content=metrics_data, media_type=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
