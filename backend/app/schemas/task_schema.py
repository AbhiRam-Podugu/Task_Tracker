from pydantic import BaseModel
from datetime import date
from typing import Optional


class TaskBase(BaseModel):
    title: str
    description: str
    due_date: date
    status: str
    blocked_by: Optional[int] = None


class TaskCreate(TaskBase):
    pass


class TaskUpdate(TaskBase):
    pass


class TaskResponse(TaskBase):
    id: int

    class Config:
        from_attributes = True
