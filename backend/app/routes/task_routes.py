from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional

from app.models.task import Task
from app.schemas.task_schema import TaskCreate, TaskUpdate, TaskResponse
from app.database.deps import get_db

router = APIRouter(prefix="/tasks", tags=["Tasks"])


# CREATE TASK
@router.post("/", response_model=TaskResponse)
def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    new_task = Task(**task.dict())

    db.add(new_task)
    db.commit()
    db.refresh(new_task)

    return new_task


# GET ALL TASKS (SEARCH + FILTER)
@router.get("/", response_model=List[TaskResponse])
def get_tasks(
    search: Optional[str] = None,
    status: Optional[str] = None,
    db: Session = Depends(get_db),
):
    query = db.query(Task)

    if search:
        query = query.filter(Task.title.contains(search))

    if status:
        query = query.filter(Task.status == status)

    return query.all()


# GET SINGLE TASK
@router.get("/{task_id}", response_model=TaskResponse)
def get_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if not task:
        raise HTTPException(status_code=404, detail="Task not found")

    return task


# UPDATE TASK
@router.put("/{task_id}", response_model=TaskResponse)
def update_task(task_id: int, updated: TaskUpdate, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if not task:
        raise HTTPException(status_code=404, detail="Task not found")

    for key, value in updated.dict().items():
        setattr(task, key, value)

    db.commit()
    db.refresh(task)

    return task


# DELETE TASK
@router.delete("/{task_id}")
def delete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if not task:
        raise HTTPException(status_code=404, detail="Task not found")

    db.delete(task)
    db.commit()

    return {"message": "Task deleted"}