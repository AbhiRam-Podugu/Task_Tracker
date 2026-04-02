from fastapi import FastAPI
from app.database.db import engine, Base
from app.models import task
from app.routes.task_routes import router as task_router

app = FastAPI()

Base.metadata.create_all(bind=engine)

app.include_router(task_router)


@app.get("/")
def root():
    return {"message": "Task Management API is running"}